#if(CLIENT)
global function ClImagePakLoadInit
global function RequestDownloadedImagePakLoad
global function ClientCodeCallback_OnRpakDownloadComplete
global function ClientCodeCallback_OnRpakDownloadFailed
global function UIScriptResetCallback_ImagePakLoad
global function SetIsPromoImageHijacked
#endif

#if(UI)
global function GetDownloadedImageAsset
global function IsImagePakLoading
global function DidImagePakLoadFail
global function UISetRpakLoadStatus
global function ImagePakLoad_OnLevelShutdown
global function ImagePakLoad_UIScriptResetComplete
#endif

#if CLIENT || UI 
global enum ePakType
{
	DEFAULT,
	//
	DL_PROMO,
	DL_MINI_PROMO,
	DL_STORE,
}
#endif

#if CLIENT || UI 
enum eImagePakLoadStatus
{
	LOAD_REQUESTED,
	LOAD_DEFERRED,
	LOAD_COMPLETED,
	LOAD_FAILED,
}
#endif

#if(CLIENT)
global struct sImagePakLoadRequest
{
	var imageElem
	asset imageRef
	string rpakName
	int pakType
}
#endif

struct
{
#if(CLIENT)
	array<PakHandle> pakHandles
	array<sImagePakLoadRequest> activePakLoadReqs
	array<sImagePakLoadRequest> deferredPakLoadReqs
	bool isPromoImageHijacked = false
#endif

#if CLIENT || UI 
	table<string, int> pakLoadStatuses
#endif
} file


#if(CLIENT)
void function ClImagePakLoadInit()
{
	RegisterSignal( "RequestDownloadedImagePakLoad" )
	file.pakLoadStatuses.clear()
}
#endif

#if(UI)
void function ImagePakLoad_OnLevelShutdown()
{
	file.pakLoadStatuses.clear()
}
#endif

#if CLIENT || UI 
asset function GetDownloadedImageAssetFromString( string rpakName, string imageName, int dlType )
{
	asset image = $""
	string fullImageName = ""

	if ( imageName == "" )
		return image
	else if ( dlType == ePakType.DL_PROMO )
		fullImageName = "rui/download_promo/" + imageName
	else if ( dlType == ePakType.DL_MINI_PROMO )
		fullImageName = "rui/download_mini_promo/" + imageName
	else if ( dlType == ePakType.DL_STORE )
		fullImageName = "rui/download_store/" + imageName

	if( RuiImageExists( fullImageName ) )
	{
		image = GetAssetFromString( fullImageName )
	}
	else
	{
		printt( "Couldn't find image", fullImageName, "in rpak:", rpakName, "- Will use fallback image." )
		image = GetFallbackImage( dlType )
	}

	return image
}
#endif

#if CLIENT || UI 
asset function GetFallbackImage( int dlType )
{
	asset image = $""
	if( dlType == ePakType.DL_STORE )
		image = $"rui/menu/image_download/image_load_failed_store_tall"
	else if ( dlType == ePakType.DL_PROMO )
		image = $"rui/menu/image_download/image_load_failed_promo"
	else if ( dlType == ePakType.DL_MINI_PROMO )
		image = $"rui/menu/image_download/image_load_failed_mini_promo"

	return image
}
#endif

#if CLIENT || UI 
asset function GetDownloadedImageAsset( string rpakName, string imageName, int dlType, var imageElem = null )
{
	asset image = $""

	if( rpakName in file.pakLoadStatuses )
	{
		int status = file.pakLoadStatuses[rpakName]
		bool isLoading = status < eImagePakLoadStatus.LOAD_COMPLETED

		if( status == eImagePakLoadStatus.LOAD_FAILED )
		{
			image = GetFallbackImage( dlType )
			SetLoadingStateOnImage( rpakName, dlType, imageElem, isLoading )
			return image
		}

		if( isLoading )
			image = $""
		else
			image = GetDownloadedImageAssetFromString( rpakName, imageName, dlType )
	}
	#if(UI)
		if( CanRunClientScript() )
			RunClientScript( "RequestDownloadedImagePakLoad", rpakName, dlType, imageElem, imageName )
	#endif

	return image
}
#endif

#if(UI)
bool function IsImagePakLoading( string rpakName )
{
	if( rpakName in file.pakLoadStatuses )
		return file.pakLoadStatuses[rpakName] == eImagePakLoadStatus.LOAD_REQUESTED || file.pakLoadStatuses[rpakName] == eImagePakLoadStatus.LOAD_DEFERRED

	return false
}
#endif

#if(UI)
bool function DidImagePakLoadFail( string rpakName )
{
	if( rpakName in file.pakLoadStatuses )
		return file.pakLoadStatuses[rpakName] == eImagePakLoadStatus.LOAD_FAILED

	return false
}
#endif

#if(UI)
void function UISetRpakLoadStatus( string rpakName, int status )
{
	file.pakLoadStatuses[rpakName] <- status
}
#endif

#if(CLIENT)
void function SetRpakLoadStatus( string rpakName, int status )
{
	if( !IsLobby() )
		return

	file.pakLoadStatuses[rpakName] <- status

	//
	RunUIScript( "UISetRpakLoadStatus", rpakName, status )
}
#endif

//
#if(UI)
void function ImagePakLoad_UIScriptResetComplete()
{
	if ( CanRunClientScript() )
		RunClientScript( "UIScriptResetCallback_ImagePakLoad" )
}
#endif

#if(CLIENT)
void function UIScriptResetCallback_ImagePakLoad()
{
	if( !IsLobby() )
		return

	//
	foreach( rpakName, status in file.pakLoadStatuses )
		RunUIScript( "UISetRpakLoadStatus", rpakName, status )

	//
	foreach( req in file.activePakLoadReqs )
		req.imageElem = null
}
#endif

#if(CLIENT)
void function SetIsPromoImageHijacked( bool isHijacked )
{
	file.isPromoImageHijacked = isHijacked
}
#endif

#if(CLIENT)
void function ClientCodeCallback_OnRpakDownloadComplete()
{
	for( int i = file.deferredPakLoadReqs.len() - 1; i >= 0; i-- )
	{
		sImagePakLoadRequest imgLoadRequest = file.deferredPakLoadReqs[i]
		int fileDownloadStatus = GetDownloadedFileStatus( imgLoadRequest.rpakName )

		if ( fileDownloadStatus == ASSET_DOWNLOAD_STATUS_UP_TO_DATE )
		{
			printt( "IMG_DL Load for", imgLoadRequest.rpakName, "was initially deferred, but the file is now downloaded and ready for pak load." )
			file.activePakLoadReqs.append( imgLoadRequest )
			file.deferredPakLoadReqs.remove(i)
			thread RequestDownloadedImagePakLoad_Internal( imgLoadRequest.rpakName, imgLoadRequest.pakType, imgLoadRequest.imageElem, imgLoadRequest.imageRef )
			return
		}
	}
}
#endif

#if(CLIENT)
void function ClientCodeCallback_OnRpakDownloadFailed( string rpakName )
{
	bool wasPakLoadAttempted = rpakName in file.pakLoadStatuses

	if( wasPakLoadAttempted )
	{
		int status = file.pakLoadStatuses[rpakName]
		sImagePakLoadRequest req

		if ( status == eImagePakLoadStatus.LOAD_REQUESTED )
		{
			for( int i = file.activePakLoadReqs.len() - 1; i >= 0; i-- )
			{
				if( rpakName == file.activePakLoadReqs[i].rpakName )
				{
					req = file.activePakLoadReqs[i]
					file.activePakLoadReqs.remove(i)
				}
			}
		}
		else if ( status == eImagePakLoadStatus.LOAD_DEFERRED )
		{
			for( int i = file.deferredPakLoadReqs.len() - 1; i >= 0; i-- )
			{
				if( rpakName == file.deferredPakLoadReqs[i].rpakName )
				{
					req = file.deferredPakLoadReqs[i]
					file.deferredPakLoadReqs.remove(i)
				}
			}
		}
		//
		SetLoadingStateOnImage( rpakName, req.pakType, req.imageElem, false )
	}
	SetRpakLoadStatus( rpakName, eImagePakLoadStatus.LOAD_FAILED )
}
#endif

#if CLIENT || UI 
void function SetLoadingStateOnImage( string rpakName, int pakType, var imageElem, bool isLoading )
{
	if( imageElem )
	{
		RuiSetBool( Hud_GetRui( imageElem ), "isImageLoading", isLoading )
		asset image = isLoading ? $"" : GetDownloadedImageAssetFromString( rpakName, "", pakType )

		RuiSetImage( Hud_GetRui( imageElem ), "imageAsset", image )
	}
}
#endif

#if(CLIENT)
void function UpdateExistingRequestImage( string rpakName, var imageElem, asset imageRef )
{
	//
	//
	foreach( req in file.activePakLoadReqs )
	{
		if ( req.imageElem == null && imageElem != null && req.rpakName == rpakName )
		{
			req.imageElem = imageElem
			req.imageRef = imageRef
		}
	}
}
#endif

#if(CLIENT)
void function RequestDownloadedImagePakLoad( string rpakName, int pakType, var imageElem = null, asset imageRef = $"" )
{
	if( rpakName == "" || pakType == ePakType.DEFAULT )
		return

	//
	if( rpakName in file.pakLoadStatuses )
	{
		bool isWaitingForLoad = file.pakLoadStatuses[rpakName] < eImagePakLoadStatus.LOAD_COMPLETED
		if( isWaitingForLoad )
			UpdateExistingRequestImage( rpakName, imageElem, imageRef )
		SetLoadingStateOnImage( rpakName, pakType, imageElem, isWaitingForLoad )
		return
	}

	SetRpakLoadStatus( rpakName, eImagePakLoadStatus.LOAD_REQUESTED )
	SetLoadingStateOnImage( rpakName, pakType, imageElem, true )

	sImagePakLoadRequest imgReq
	imgReq.imageElem = imageElem
	imgReq.imageRef = imageRef
	imgReq.rpakName = rpakName
	imgReq.pakType = pakType

	int fileDownloadStatus = GetDownloadedFileStatus( rpakName )

	if( fileDownloadStatus == ASSET_DOWNLOAD_STATUS_FAILED )
	{
		SetRpakLoadStatus( rpakName, eImagePakLoadStatus.LOAD_FAILED )
		return
	}
	else if( fileDownloadStatus == ASSET_DOWNLOAD_STATUS_UP_TO_DATE || fileDownloadStatus == ASSET_DOWNLOAD_STATUS_USED_RECENTLY )
	{
		file.activePakLoadReqs.append( imgReq )
		thread RequestDownloadedImagePakLoad_Internal( rpakName, pakType, imageElem, imageRef )
	}
	else
	{
		//
		file.deferredPakLoadReqs.append( imgReq )
		SetRpakLoadStatus( rpakName, eImagePakLoadStatus.LOAD_DEFERRED )
	}
}
#endif

#if(CLIENT)
void function RequestDownloadedImagePakLoad_Internal( string rpakName, int pakType, var imageElem = null, asset imageRef = $"" )
{
	if( !IsLobby() )
		return

	Signal( clGlobal.signalDummy, "RequestDownloadedImagePakLoad" )
	EndSignal( clGlobal.signalDummy, "RequestDownloadedImagePakLoad" )

	PakHandle pakHandle = RequestPakFile( rpakName )
	pakHandle.pakType = pakType
	file.pakHandles.append( pakHandle )

	if ( !pakHandle.isAvailable )
		WaitSignal( pakHandle, "PakFileLoaded" )

	foreach( req in file.activePakLoadReqs )
	{
		SetRpakLoadStatus( req.rpakName, eImagePakLoadStatus.LOAD_COMPLETED )
		SetDownloadedFileStatus( req.rpakName, ASSET_DOWNLOAD_STATUS_USED_RECENTLY )

		if( req.pakType == ePakType.DL_PROMO )
			RunUIScript( "OpenPromoDialogIfNewAfterPakLoad" )

		if( req.imageElem )
		{
			RuiSetBool( Hud_GetRui( req.imageElem ), "isImageLoading", false )

			if( req.imageRef != $"" )
			{
				printt( "IMG_DL PakFileLoaded - Setting image to", req.imageRef, "on", Hud_GetHudName( req.imageElem ) )
				asset imageAsset = GetDownloadedImageAssetFromString( req.rpakName, req.imageRef, req.pakType )
				if( req.pakType == ePakType.DL_STORE )
					RuiSetImage( Hud_GetRui( req.imageElem ), "imageAsset", imageAsset )
				else if ( req.pakType == ePakType.DL_PROMO && !file.isPromoImageHijacked )
					RuiSetImage( Hud_GetRui( req.imageElem ), "imageAsset", imageAsset )
				else if( req.pakType == ePakType.DL_MINI_PROMO )
					RuiSetImage( Hud_GetRui( req.imageElem ), "imageAsset", imageAsset )
			}
		}
	}
	file.activePakLoadReqs.clear()

	//
	if( pakType != ePakType.DL_STORE )
	{
		foreach( handle in file.pakHandles )
		{
			if ( handle != pakHandle && handle.pakType == pakType && handle.isAvailable )
			{
				printt( "IMG_DL Releasing pak file:", handle.rpakPath, "handle.pakType:", handle.pakType, "pakType:", pakType )
				ReleasePakFile( handle )
			}
		}
	}

	WaitForever()
}
#endif