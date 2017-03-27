/**
 * RTP Handler
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */

/**
 * Class for handling RTP and all its nuances
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class RTP {

	strFileConf		:= "conf\rtp.ini"

	strProcess		:= "rtponecontainer"
	idProcess		:=

	strPrefix		:= "WindowsForms10"
	strType			:= "Window.8"
	strSuffix		:= "app.0.30495d1"
	intWindow		:= 11
	intElement		:= 1
	strTitle		:= "RTP|ONE Container"


	/**
	 * Constructor
	 * Reads INI config file and builds RTP ClassNN identifier
	 * @return rtp
	 */
	__New() {
		IniRead, strPrefix, % this.strFileConf, Conf, Prefix, WindowsForms10
		this.strPrefix := strPrefix
		IniRead, strType, % this.strFileConf, Conf, Type, Window.8
		this.strType := strType
		IniRead, strSuffix, % this.strFileConf, Conf, Suffix, app.0.30495d1
		this.strSuffix := strSuffix
		IniRead, intWindow, % this.strFileConf, Conf, Window, 11
		this.intWindow := intWindow
		IniRead, intElement, % this.strFileConf, Conf, Element, 1
		this.intElement := intElement
		IniRead, strTitle, % this.strFileConf, Conf, Title, 1
		this.strTitle := strTitle

		strRTP := this.ClassNN()
		WinGet, idWinRTP, ID, %strTitle% ahk_class %strRTP%
		this.idProcess := idWinRTP
	}

	setID( idWin ) {
		this.idProcess := idWin
	}

	getID() {
		return this.idProcess
	}

	/**
	 * Returns ClassNN identifier of RTP window
	 *
	 * @uses formatClassNN
	 * @return string ClassNN for RTP
	 */
	ClassNN() {
		return this.formatClassNN( this.strType, this.intElement )
	}

	/**
	 * Returns Formatted ClassNN identifier for a RTP UI element
	 *
	 * @param string Type Element type (static, combobox, etc)
	 * @param int Element Integer identifier of RTP UI element
	 *
	 * @return string ClassNN for element
	 */
	formatClassNN( strType, intElement ) {
		return % this.strPrefix "." strType "." this.strSuffix "_r" this.intWindow "_ad" intElement
	}

	/**
	 * Restore (if needed) and activate RTP window
	 *
	 * @return void
	 */
	Activate() {
		Window.ActivateRestore( this.idProcess )
	}

	/**
	 * Checks if RTP is the active process
	 *
	 * @return bool
	 */
	isActive() {
		return Window.checkActiveProcess( this.strProcess )
	}

}
