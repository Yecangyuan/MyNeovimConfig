return {
  "echasnovski/mini.animate",
  version = false,
  event = "VeryLazy",
  config = function()
    require('mini.animate').setup({
      -- 滚动动画
      scroll = {
        -- 启用滚动动画
        enable = true,
        
        -- 滚动的时长(ms)
        timing = function(_, steps) return 150 end,
        
        -- 滚动的缓动函数
        -- 选项: linear, quadratic, cubic, quartic, quintic, circular, sine
        easing = 'quadratic',
        
        -- 滚动步骤生成函数
        subscroll = function(total_steps)
          local displacement = math.max(1, math.floor(0.3 * total_steps))
          return {
            { steps = total_steps, displacement = displacement },
          }
        end,
      },
      
      -- 光标移动动画
      cursor = {
        -- 启用光标动画
        enable = true,
        
        -- 动画时长(ms)
        timing = function(_, steps) return 120 end,
        
        -- 缓动函数
        easing = 'quadratic',
        
        -- 路径生成函数 - 必须是函数而不是字符串
        path = function(state)
          -- 使用直线路径
          return require('mini.animate').gen_path.line(state)
        end,
      },
      
      -- 窗口调整大小动画
      resize = {
        -- 启用窗口调整大小动画
        enable = true,
        
        -- 动画时长(ms)
        timing = function(_, steps) return 120 end,
        
        -- 缓动函数
        easing = 'quadratic',
        
        -- 窗口调整步骤生成函数
        subresize = function(total_steps)
          return { steps = total_steps, size_ratio = 0.3 }
        end,
      },
      
      -- 打开/关闭窗口动画
      open = {
        -- 启用打开窗口动画
        enable = true,
        
        -- 动画时长(ms)
        timing = function(_, steps) return 180 end,
        
        -- 缓动函数
        easing = 'quadratic',
        
        -- 窗口打开步骤生成函数
        winconfig = function(_, total_steps)
          -- 从中心向外展开
          return { row = 0.5, col = 0.5, width = 0.0, height = 0.0 }
        end,
        
        -- 打开窗口步骤生成函数
        subopen = function(total_steps)
          return { steps = total_steps }
        end,
      },
      
      -- 关闭窗口动画
      close = {
        -- 启用关闭窗口动画
        enable = false, -- 禁用关闭动画，避免某些情况下的视觉干扰
      },
    })
  end,
} 