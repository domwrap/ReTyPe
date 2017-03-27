

class RTP {

	strProcess :=
	idProcess :=
	idRtpClassNN := 

	__New() {
		global objRetype

		IniRead, idRtpClassNN, objRetype.strFileConf, Conf, RtpClassNN
		this.idRtpClassNN := idRtpClassNN
	}

	isActive() {
		Window.checkActiveProcess( "rtponecontainer" )
	}



}