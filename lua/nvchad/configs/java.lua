-- 定义项目根目录标记
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1])

local MASON = "~/.local/share/nvim/mason"

-- 计算工作区目录
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
vim.fn.mkdir(workspace_dir, "p")

-- 验证操作系统
if not (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1 or vim.fn.has "win32" == 1) then
  vim.notify("[nvim-jdtls] Unsupported operating system.", vim.log.levels.ERROR)
end

-- 配置 jdtls 的 cmd 参数
local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-javaagent:" .. vim.fn.expand "$MASON/packages/jdtls/lombok.jar",
  "-Xms1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens=java.base/java.util=ALL-UNNAMED",
  "--add-opens=java.base/java.lang=ALL-UNNAMED",
  "-jar",
  vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
  "-configuration",
  vim.fn.expand "$MASON/share/jdtls/config",
  "-data",
  workspace_dir,
}

local settings = {
  java = {
    eclipse = { downloadSources = true },
    configuration = { updateBuildConfiguration = "interactive" },
    maven = { downloadSources = true },
    implementationsCodeLens = { enabled = true },
    referencesCodeLens = { enabled = true },
    inlayHints = { parameterNames = { enabled = "all" } },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
  },
}

-- local init_options = {
--   bundles = {
--     vim.fn.expand "~/.local/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
--     unpack(vim.split(vim.fn.glob "~/.local/share/java-test/*.jar", "\n")),
--   },
-- }

local handlers = {
  ["$/progress"] = function() end, -- 禁用进度更新
}

local config = {
  cmd = cmd,
  root_dir = root_dir,
  settings = settings,
  -- init_options = init_options,
  handlers = handlers,
}

require("jdtls").start_or_attach(config)
