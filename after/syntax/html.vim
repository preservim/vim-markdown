" fix issue with less than sign https://github.com/preservim/vim-markdown/issues/138
syn clear htmlTag
syn region htmlTag start=+<[^/]+ end=+>+ fold oneline contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster

