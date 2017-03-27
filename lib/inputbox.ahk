
class InputBox {

	static title := "ReTyPe"

	/**
	 * Displays an input box to ask the user to enter a string
	 * 
	 * @param string strMessage The message to display on the input dialogue
	 * @param mixed mixDefault The default value in the input box
	 * @param bool blnExit Control whether to return or exit on user-cancel
	 *
	 * @return mixed Mixed value of user-input
	 */
	show( strMessage, mixDefault="" ) {
		strTitle := % this.title
		InputBox, mixVar, %strTitle%, %strMessage%, , , , , , , , %mixDefault%

		if ErrorLevel {
				return False
		} else {
			return %mixVar%
		}
	}

}