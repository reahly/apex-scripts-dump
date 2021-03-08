//
//
//
//
//

global function printl
global function CodeCallback_Precompile

global struct EchoTestStruct
{
	int test1
	bool test2
	bool test3
	float test4
	vector test5
	int[5] test6
}

global struct TraceResults
{
	entity hitEnt
	vector endPos
	vector surfaceNormal
	string surfaceName
	int surfaceProp
	float fraction
	float fractionLeftSolid
	int hitGroup
	int staticPropID
	bool startSolid
	bool allSolid
	bool hitSky
	bool hitBackFace
	int contents
}

global struct VisibleEntityInCone
{
	entity ent
	vector visiblePosition
	int visibleHitbox
	bool solidBodyHit
	vector approxClosestHitboxPos
	int extraMods
}

global struct PlayerDidDamageParams
{
	entity victim
	vector damagePosition
	int hitBox
	int damageType
	float damageAmount
	int damageFlags
	int hitGroup
	entity weapon
	float distanceFromAttackOrigin
}

global struct Attachment
{
	vector position
	vector angle
}

global struct EntityScreenSpaceBounds
{
	float x0
	float y0
	float x1
	float y1
	bool outOfBorder
}

global struct BackendError
{
	int serialNum
	string errorString
}

global struct BrowseFilters
{
	string name
	string clantag
	string communityType
	string membershipType
	string category
	string playtime
	string micPolicy
	int pageNum
	int minMembers
}

global struct CommunitySettings
{
	int communityId
	bool verified
	bool doneResolving
	string name
	string clanTag
	string motd
	string communityType
	string membershipType
	string visibility
	string category
	string micPolicy
	string language1
	string language2
	string language3
	string region1
	string region2
	string region3
	string region4
	string region5
	int happyHourStart
	int matches
	int wins
	int losses
	string kills
	string deaths
	string xp
	int ownerCount
	int adminCount
	int memberCount
	int onlineNow
	bool invitesAllowed
	bool chatAllowed
	string creatorUID
	string creatorName
}

global struct CommunityMembership
{
	int communityId
	string communityName
	string communityClantag
	string membershipLevel
}

global struct CommunityFriends
{
	bool isValid
	array<string> ids
	array<string> hardware
	array<string> names
}

global struct CommunityFriendsData
{
	string id
	string hardware
	string name
	string presence
	bool online
	bool ingame
	bool away
}

global struct CommunityFriendsWithPresence
{
	bool isValid
	array<CommunityFriendsData> friends
}

global struct CommunityUserInfo
{
	string hardware
	string uid
	string name
	string kills
	int wins
	int matches
	int banReason
	int banSeconds
	int eliteStreak
	int rankScore
	string rankedPeriodName
	int rankedLadderPos
	int lastCharIdx
	bool isLivestreaming
	bool isOnline
	bool isJoinable
	bool partyFull
	bool partyInMatch
	float lastServerChangeTime
	string privacySetting
	array<int> charData

	int numCommunities
}

global struct PartyMember
{
	string name
	string uid
	string hardware
	bool ready
	bool present
	string eaid
	string clubTag
}

global struct OpenInvite
{
	string inviteType
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	float timeLeft
	bool amIInThis
	bool amILeader
	array<PartyMember> members
}


global struct Party
{
	string partyType
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	float timeLeft
	bool amIInThis
	bool amILeader
	bool searching
	array<PartyMember> members
}

global struct RemoteClientInfoFromMatchInfo
{
	string name
	int teamNum
	int score
	int kills
	int deaths
}

global struct RemoteMatchInfo
{
	string datacenter
	string gamemode
	string playlist
	string map
	int maxClients
	int numClients
	int maxRounds
	int roundsWonIMC
	int roundsWonMilitia
	int timeLimitSecs
	int timeLeftSecs
	int teamsLeft
	int maxScore
	array<RemoteClientInfoFromMatchInfo> clients
	array<int> teamScores
}

global struct InboxMessage
{
	int messageId
	string messageType
	bool deletable
	bool deleting
	bool reportable
	bool doneResolving

	string dateSent
	string senderHardware
	string senderUID
	string senderName
	int communityID
	string communityName
	string messageText
	string actionLabel
	string actionURL
}

global struct MainMenuPromos
{
	int prot,
	int version,
	string layout,
	string promoRpak,
	string miniPromoRpak
}

#if(UI)
global struct MatchmakingDatacenterETA
{
	int datacenterIdx
	string datacenterName
	int latency
	int packetLoss
	int etaSeconds
	int idealStartUTC
	int idealEndUTC
}
#endif //

#if(UI)
global struct GRXCraftingOffer
{
	int itemIdx
	int craftingPrice
}

global struct GRXStoreOfferItem
{
	int itemIdx
	int itemQuantity
	int itemType
}

global struct GRXStoreOffer
{
	array< GRXStoreOfferItem > items
	array< array< int > > prices
	table< string, string > attrs
	int offerType
	string offerAlias
}
#endif //

#if(UI)
global struct GRXBundleOffer
{
	array< array<int> >bundlePrices
	int purchaseCount
	string ineligibleReason
}
#endif

global struct GRXUserInfo
{
	int inventoryState

	int queryGoal
	int queryOwner
	int queryState
	int querySeqNum

	array< int > balances

	int marketplaceEdition

	bool isOfferRestricted
	bool hasUpToDateBundleOffers
}

#if(UI)
global struct ClubHeader
{
	string clubID
	string name
	string tag
	string logoString
	string creatorID
	string dataCenter
	int memberCount
	int privacySetting	//
	int minLevel
	int minRating
	int searchTags
	int hardware
	bool allowCrossplay
}

global struct ClubMember
{
	string memberID
	string memberName
	string platformUserID
	int memberHardware
	int rank
}

global struct ClubJoinRequest
{
	string userID
	string userName
	int userHardware
	int expireTime
}

global struct ClubEvent
{
	int eventTime
	int eventType	//
	int eventParam
	string eventText
	string memberName
	string memberID
}

global struct ClubData
{
	array< ClubMember > members
	array< ClubJoinRequest > joinRequests
	array< ClubEvent > eventLog
	array< ClubEvent > chatLog
}

global struct ClubInvite
{
	string clubID
	string name
}
#endif


global struct VortexBulletHit
{
	entity vortex
	vector hitPos
}

global struct AnimRefPoint
{
	vector origin
	vector angles
}

global struct LevelTransitionStruct
{
	//
	//

	int startPointIndex

	int[3] ints

	int[2] pilot_mainWeapons = [-1,-1]
	int[2] pilot_offhandWeapons = [-1,-1]
	int ornull[2] pilot_weaponMods = [null,null]
	int pilot_ordnanceAmmo = -1

	int titan_mainWeapon = -1
	int titan_unlocksBitfield = 0

	int difficulty = 0
}

global struct WeaponOwnerChangedParams
{
	entity oldOwner
	entity newOwner
}

global struct WeaponTossPrepParams
{
	bool isPullout
}

global struct WeaponPrimaryAttackParams
{
	vector pos
	vector dir
	bool firstTimePredicted
	int burstIndex
	int barrelIndex
}

global struct WeaponRedirectParams
{
	entity projectile
	vector projectilePos
}

global struct WeaponBulletHitParams
{
	entity hitEnt
	vector startPos
	vector hitPos
	vector hitNormal
	vector dir
}

global struct WeaponFireBulletSpecialParams
{
	vector pos
	vector dir
	int bulletCount
	int scriptDamageType
	bool skipAntiLag
	bool dontApplySpread
	bool doDryFire
	bool noImpact
	bool noTracer
	bool activeShot
	bool doTraceBrushOnly
}

global struct WeaponFireBoltParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	int additionalRandomSeed
	bool dontApplySpread
	int projectileIndex
	bool deferred //
}

global struct WeaponFireGrenadeParams
{
	vector pos
	vector vel
	vector angVel
	float fuseTime
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	bool lagCompensated
	bool useScriptOnDamage
	bool isZiplineGrenade = false
	int projectileIndex
}

global struct WeaponFireMissileParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool doRandomVelocAndThinkVars
	bool clientPredicted
	int projectileIndex
}

global struct ModInventoryItem
{
	int slot
	string mod
	string weapon
	int count
}

global struct OpticAppearanceOverride
{
	array<string>	bodygroupNames
	array<int>		bodygroupValues
	array<string>	uiDataNames
}

global struct ConsumableInventoryItem
{
	int slot
	int type
	int count
}

global struct PingCollection
{
	entity latestPing
	array<entity> locations
	array<entity> loots
}

global struct HudInputContext
{
	bool functionref(int) keyInputCallback
	bool functionref(float, float) viewInputCallback
	bool functionref(float, float) moveInputCallback
	int hudInputFlags
}

global struct SmartAmmoTarget
{
	entity ent
	float fraction
	float prevFraction
	bool visible
	float lastVisibleTime
	bool activeShot
	float trackTime
}

global struct StaticPropRui
{
	//
	//
	//
	//

	string scriptName           //
	string mockupName           //
	string modelName            //
	vector spawnOrigin			//
	vector spawnMins			//
	vector spawnMaxs			//

	vector spawnForward
	vector spawnRight
	vector spawnUp

	//
	//
	//
	//
	//
	//

	asset ruiName               //
	table<string, string> args  //

	//
	//
	//
	//
	//
	//

	int magicId
}

global struct ScriptAnimWindow
{
	entity ent
	asset settingsAsset
	string stringID
	string windowName
	float startCycle
	float endCycle
}

global struct ZiplineStationSpots
{
	asset beginStationModel
	vector beginStationOrigin
	vector beginStationAngles
	entity beginStationMoveParent
	string beginStationAnimation
	vector beginZiplineOrigin

	asset endStationModel
	vector endStationOrigin
	vector endStationAngles
	entity endStationMoveParent
	string endStationAnimation
	vector endZiplineOrigin
}

global struct WaypointClusterInfo
{
	vector clusterPos
	int numPointsNear
}

global struct NavMesh_FindMeshPath_Result
{
	bool navMeshOK
	bool startPolyOK
	bool goalPolyOK
	bool pathFound
	array<vector> points
}

global struct PrivateMatchStatsStruct
{
	string playerName
	string teamName
	string platformUid
	string hardware
	int survivalTime
	int kills
	int assists
	int damageDealt
	int teamNum
	int teamPlacement
}

global struct PrivateMatchChatConfigStruct
{
	bool	adminOnly
	int		chatMode
	int		targetIndex
	bool	spectatorChat
}

global typedef SettingsAssetGUID int

#if(UI)

global struct  EadpPresenceData
{
	int			hardware
	string		presence
	bool		partyInMatch
	bool		partyIsFull
	string		privacySetting
	string		name
	bool		online
	bool		ingame
	bool		away
	string      firstPartyId
	bool        isJoinable
}

global struct EadpPeopleData
{
	string eaid
	string name
	string platformName
	string platformHardware
	array< EadpPresenceData > presences
}

global struct EadpPeopleList
{
	bool   isValid
	array< EadpPeopleData > people
}

global struct EadpInviteToPlayData
{
	string	eaid
	string	name
	int		hardware
}

global struct EadpInviteToPlayList
{
	bool   isValid
	array< EadpInviteToPlayData > invitations
}

global struct EadpPrivacySetting
{
	bool	isValid
	string	psnIdDiscoverable
	string	xboxTagDiscoverable
	string	displayNameDiscoverable
	string	steamNameDiscoverable
	string	nxNameDiscoverable
}

global enum eFriendStatus
{
	ONLINE_INGAME,
	ONLINE,
	ONLINE_AWAY,
	OFFLINE,
	REQUEST,
	COUNT
}

global struct Friend
{
	string id
	string hardware
	string name = "Unknown"
	string presence = ""
	int    status = eFriendStatus.OFFLINE
	bool   ingame = false
	bool   inparty = false
	bool   away = false

	EadpPeopleData ornull eadpData
}

global struct FriendsData
{
	array<Friend> friends
	bool          isValid
}
#endif //
//
//
//

void function printl( var text )
{
	return print( text + "\n" )
}

void function CodeCallback_Precompile()
{
#if(DEV)
	//
	//
		getroottable().originalConstTable <- clone getconsttable()
#endif
}




