if PlugIsNotInstalled('sonokai')
  finish
endif

if has('termguicolors')
  " Enable true color (24-bit color) in the TUI.
  set termguicolors
endif

" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_better_performance = 1

colorscheme sonokai
