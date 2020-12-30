question_css = """
<style>
div.question {
  padding-left: 20px;
  padding-right: 20px;
  padding-top: 10px;
  padding-bottom: 10px;
  border: 3px dotted lightgrey;
  border-radius: 15px;
  background: #F8F8F8;
}
</style>"""

fyi_css = html"""
<style> pluto-output div.admonition.info .admonition-title {
        background: rgb(161, 161, 161);
      } 

      pluto-output div.admonition.info {
        background: rgba(161, 161, 161, 0.2);
        border: 5px solid rgb(161, 161, 161);
      }
</style>"""

bomb_css = html"""
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
</style>"""