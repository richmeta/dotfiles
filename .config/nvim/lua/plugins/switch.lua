return {
	"AndrewRadev/switch.vim",

	config = function()
		vim.g.switch_custom_definitions = {
			{
				-- dd/mm/yyyy to isodate
				[ [[\(\d\+\)[/.-]\(\d\+\)[/.-]\(\d\+\)]] ] = [[\3-\2-\1]],

				-- 'X \w+ Y' to 'Y \w+ X'
				[ [[\(\w\+\)\(\s\+\w\+\s\+\)\(\w\+\)]] ] = [[\3\2\1]],
			},
			vim.fn["switch#NormalizedCase"]({ "true", "false" }),
			vim.fn["switch#NormalizedCase"]({ "yes", "no" }),
			vim.fn["switch#NormalizedCase"]({ "enabled", "disabled" }),
		}
	end,
}
