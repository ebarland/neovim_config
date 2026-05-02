-- lua/plugins/dap.lua
return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
			{ "<S-F5>", function() require("dap").terminate() end, desc = "Debug: Stop" },
			{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
			{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
			{ "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
			{ "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
			{ "<leader>dB", function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, desc = "Debug: Conditional Breakpoint" },
			{ "<leader>dl", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, desc = "Debug: Log Point" },
			{ "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: REPL" },
		},
	},
	{
		"mfussenegger/nvim-dap",
		ft = { "cs" },
		config = function()
			local dap = require("dap")
			local platform = require("config.platform")
			if not dap.adapters.coreclr then
				dap.adapters.coreclr = {
					type = "executable",
					command = vim.fs.joinpath(
						vim.fn.stdpath("data"),
						"mason", "packages", "netcoredbg",
						platform.is_win and "netcoredbg/netcoredbg.exe" or "netcoredbg"
					),
					args = { "--interpreter=vscode" },
				}
			end

			-- Find the solution root (directory containing .sln)
			local function find_sln_root()
				local sln = vim.fs.find(function(name) return name:match("%.sln$") end, {
					upward = true, type = "file", path = vim.fn.getcwd(),
				})[1]
				return sln and vim.fn.fnamemodify(sln, ":h") or vim.fn.getcwd()
			end

			local startup_file = ".nvim-dap-startup"

			-- Read the saved startup project path (relative to sln root)
			local function read_startup_project()
				local root = find_sln_root()
				local path = root .. "/" .. startup_file
				if vim.fn.filereadable(path) == 1 then
					local line = vim.fn.readfile(path)[1]
					if line and line ~= "" then return root .. "/" .. line end
				end
				return nil
			end

			-- Parse .sln and return list of { name, relative_dir } for each project
			local function parse_sln_projects()
				local root = find_sln_root()
				local sln = vim.fn.glob(root .. "/*.sln")
				if sln == "" then return {} end
				local first_sln = vim.split(sln, "\n")[1]
				local lines = vim.fn.readfile(first_sln)
				local projects = {}
				for _, line in ipairs(lines) do
					local rel_csproj = line:match('Project%b"".-"(.-%.csproj)"')
					if rel_csproj then
						-- Normalize backslashes from .sln format
						rel_csproj = rel_csproj:gsub("\\", "/")
						local proj_dir = vim.fn.fnamemodify(rel_csproj, ":h")
						local proj_name = vim.fn.fnamemodify(rel_csproj, ":t:r")
						table.insert(projects, { name = proj_name, dir = proj_dir })
					end
				end
				return projects
			end

			-- Find dll for a given project directory (relative to sln root)
			local function find_dll_in_project(proj_dir)
				local root = find_sln_root()
				local abs_dir = root .. "/" .. proj_dir
				local csproj = vim.fn.glob(abs_dir .. "/*.csproj")
				if csproj == "" then return nil end
				local name = vim.fn.fnamemodify(vim.split(csproj, "\n")[1], ":t:r")
				local matches = vim.fn.glob(abs_dir .. "/bin/Debug/**/" .. name .. ".dll", false, true)
				return matches[1]
			end

			-- Pick startup project via vim.ui.select and save to .nvim-dap-startup
			local function pick_startup_project(callback)
				local projects = parse_sln_projects()
				if #projects == 0 then
					vim.notify("No .sln found or no projects in solution", vim.log.levels.WARN)
					return
				end
				vim.ui.select(projects, {
					prompt = "Select startup project:",
					format_item = function(item) return item.name .. "  (" .. item.dir .. ")" end,
				}, function(choice)
					if not choice then return end
					local root = find_sln_root()
					vim.fn.writefile({ choice.dir }, root .. "/" .. startup_file)
					vim.notify("Startup project set: " .. choice.name)
					if callback then callback(choice.dir) end
				end)
			end

			-- Resolve the dll to launch: saved startup project > picker
			local function resolve_program()
				local proj_dir = read_startup_project()
				if proj_dir then
					-- proj_dir is absolute here, make it relative for find_dll_in_project
					local root = find_sln_root()
					local rel = proj_dir:sub(#root + 2) -- strip root + "/"
					local dll = find_dll_in_project(rel)
					if dll then return dll end
					vim.notify("No dll found for startup project, rebuild or re-select", vim.log.levels.WARN)
				end
				-- No saved project or dll not found — use coroutine to wait for picker
				local co = coroutine.running()
				pick_startup_project(function(dir)
					local dll = find_dll_in_project(dir)
					if dll then
						coroutine.resume(co, dll)
					else
						vim.notify("No dll found — run dotnet build first", vim.log.levels.ERROR)
						coroutine.resume(co, nil)
					end
				end)
				return coroutine.yield()
			end

			vim.api.nvim_create_user_command("DapStartupProject", function()
				pick_startup_project()
			end, { desc = "Set .NET startup project for debugging" })

			if not dap.configurations.cs then
				dap.configurations.cs = {
					{
						type = "coreclr",
						name = "Launch (netcoredbg)",
						request = "launch",
						program = resolve_program,
					},
					{
						type = "coreclr",
						name = "Attach (netcoredbg)",
						request = "attach",
						processId = function()
							return require("dap.utils").pick_process()
						end,
					},
				}
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
		end,
	},
}
