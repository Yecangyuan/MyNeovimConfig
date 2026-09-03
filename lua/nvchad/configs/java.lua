-- jdtls 配置（由 nvim-jdtls 在首次打开 java 文件时延迟加载）
local override = require "override.lspconfig"

-- 项目根目录标记：从当前文件向上查找，找不到则回退到 cwd
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".project" }
local fname = vim.api.nvim_buf_get_name(0)
local start_path = fname ~= "" and vim.fs.dirname(fname) or vim.fn.getcwd()
local root = vim.fs.find(root_markers, { upward = true, path = start_path })[1]
local root_dir = root and vim.fn.fnamemodify(root, ":h") or vim.fn.getcwd()

local MASON = vim.fn.stdpath "data" .. "/mason"
-- jdtls 自身需要 Java 21+ 才能运行（默认 java 是 17，会被拒绝）
local JAVA_HOME = "/Users/simley/Library/Java/JavaVirtualMachines/azul-21.0.3/Contents/Home"

-- 计算工作区目录
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
vim.fn.mkdir(workspace_dir, "p")

-- 验证操作系统
if not (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1 or vim.fn.has "win32" == 1) then
  vim.notify("[nvim-jdtls] Unsupported operating system.", vim.log.levels.ERROR)
end

-- 配置 jdtls 的 cmd 参数
local cmd = {
  JAVA_HOME .. "/bin/java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-javaagent:" .. MASON .. "/packages/jdtls/lombok.jar",
  "-Xms1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens=java.base/java.util=ALL-UNNAMED",
  "--add-opens=java.base/java.lang=ALL-UNNAMED",
  "-jar",
  MASON .. "/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
  "-configuration",
  MASON .. "/packages/jdtls/config_mac_arm",
  "-data",
  workspace_dir,
}

local settings = {
  java = {
    eclipse = { downloadSources = true },
    configuration = {
      updateBuildConfiguration = "interactive",
      runtimes = {
        {
          name = "JavaSE-21",
          path = "/Users/simley/Library/Java/JavaVirtualMachines/azul-21.0.3/Contents/Home",
        },
      },
    },
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

local handlers = {
  ["$/progress"] = function() end, -- 禁用进度更新
}

local config = {
  cmd = cmd,
  root_dir = root_dir,
  settings = settings,
  handlers = handlers,
  on_attach = override.on_attach,
  capabilities = override.capabilities,
}

require("jdtls").start_or_attach(config)
