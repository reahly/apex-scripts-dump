#if CLIENT || UI 
global function TimeGatedLoginRewards_Init
global function LoginEvent_GetLoginRewards
#endif


#if CLIENT || UI 
struct FileStruct_LifetimeLevel
{
	#if(false)

#endif
}
#endif


#if(CLIENT)
FileStruct_LifetimeLevel fileLevel //
#elseif(UI)
FileStruct_LifetimeLevel& fileLevel //

struct {
	//
} fileVM //
#endif


#if CLIENT || UI 
void function TimeGatedLoginRewards_Init()
{
	#if(UI)
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	#if(false)

#endif
}
#endif


#if CLIENT || UI 
array<ItemFlavor> function GetActiveLoginEvents( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	array<ItemFlavor> activeEvents
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_login ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		activeEvents.append( ev )

	}

	return activeEvents
}
#endif


#if(false)














//















//























#endif


#if CLIENT || UI 
array<ItemFlavor> function LoginEvent_GetLoginRewards( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_login )

	array<ItemFlavor> rewards = []
	foreach ( var rewardBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "loginRewards" ) )
	{
		asset rewardAsset = GetSettingsBlockAsset( rewardBlock, "flavor" )
		if ( IsValidItemFlavorSettingsAsset( rewardAsset ) )
			rewards.append( GetItemFlavorByAsset( rewardAsset ) )
	}
	return rewards
}
#endif
