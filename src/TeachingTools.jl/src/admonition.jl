hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

correct(text=md"Well done!") = Markdown.MD(Markdown.Admonition("correct", "Correct", [text]))

incorrect(text=md"Keep working on it !") = Markdown.MD(Markdown.Admonition("warning", "Incorrect", [text]))

fyi(text) = Markdown.MD(
	Markdown.Admonition("info",
		"Additional info",
		[html"""
			<style> pluto-output div.admonition.info .admonition-title {
						background: rgb(161, 161, 161);
					} 

					pluto-output div.admonition.info {
						background: rgba(161, 161, 161, 0.2);
						border: 5px solid rgb(161, 161, 161);
					}
			</style>
		""",
			text
		]
	)
)

bomb(text) = Markdown.MD(
	Markdown.Admonition("bomb",
		"Self destruct warning",
		[html"""
			<style> pluto-output div.admonition.bomb .admonition-title {
						background: rgb(226, 157, 148);
						animation:blinkingBox 1.5s infinite;
					} 

					pluto-output div.admonition.bomb {
						background: rgba(226, 157, 148, 0.2);
						border: 5px solid rgb(226, 157, 148);
						animation:blinkingBox 1.5s infinite;
					}

			@keyframes blinkingBox{
				0%{     visibility: hidden;    }
				30%{    visibility: hidden; }
				31%{    visibility: visible; }
				99%{    visibility: visible;  }
				100%{   visibility: hidden;     }
			}
			</style>
		""",
			text
		]
	)
)