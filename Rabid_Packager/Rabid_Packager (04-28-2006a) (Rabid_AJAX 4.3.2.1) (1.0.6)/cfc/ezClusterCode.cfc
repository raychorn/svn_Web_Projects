<cfcomponent displayname="ezClusterCode" output="No" extends="commonCode">
	<cfscript>
		this.bots_list = 'acme.spider,ahoythehomepagefinder,aleksika spider,ia_archiver,alkaline,emcspider,antibot,arachnophilia,architext,aretha,ariadne,arks,aspider,atn.txt,atomz,auresys,awbot,backrub,baiduspider,bigbrother,bjaaland,blackwidow,blogsphere,isspider,blogshares bot,blogvisioneye,blogwatcher,blogwise.com-metachecker,bloodhound,bobby,bordermanager,boris,bravobrian bstop,brightnet,bspider,bumblebee,catvschemistryspider,calif[^r],cassandra,ccgcrawl,checkbot,christcrawler,churl,cj spider,cmc,collective,combine,computer_and_automation_research_institute_crawler,robi,conceptbot,coolbot,cosmixcrawler,crawlconvera,cscrawler,cusco,cyberspyder,cydralspyder,daviesbot,deepindex,denmex websearch,deweb,blindekuh,dienstspider,digger,webreader,cgireader,diibot,digout4u,directhit,dnabot,downes/referrers,download_express,dragonbot,dwcp,e-collector,e-societyrobot,ebiness,echo,eit,elfinbot,emacs,enterprise_search,esther,evliyacelebi,exabot,exactseek,exalead ng,ezresult,fangcrawl,fast-webcrawler,fastbuzz.com,faxobot,feedster crawler,felix,fetchrover,fido,[^a]fish,flurry,fdse,fouineur,franklin locator,freecrawl,frontier,funnelweb,gaisbot,galaxybot,gama,gazz,gcreep,getbot,puu,geturl,gigabot,gnodspider,golem,googlebot,gornker,grapnel,griffon,gromit,grub-client,hambot,hatena antenna,havindex,octopus,hometown,htdig,htmlgobble,pitkow,hyperdecontextualizer,finnish,irobot,iajabot,ibm,illinois tate tech labs,imagelock,incywincy,informant,infoseek,infoseeksidewinder,infospider,ilse,ingrid,slurp,inspectorwww,intelliagent,cruiser,internet ninja,myweb,internetseer,iron33,israelisearch,javabee,jbot,jcrawler,jeeves,jennybot,jetbot,jobo,jobot,joebot,jumpstation,justview,katipo,kdd,kilroy,fireball,ko_yappo_robot,labelgrabber.txt,larbin,legs,linkidator,linkbot,linkchecker,linkfilter.net url verifier,linkscan,linkwalker,lockon,logo_gif,lycos,mac finder,macworm,magpie,marvin,mattie,mediafox,mediapartners-google,mercator,mercubot,merzscope,mindcrawler,moget,momspider,monster,mixcat,motor,mozdex,msiecrawler,msnbot,muscatferret,mwdsearch,my little bot,naverrobot,naverbot,meshexplorer,nederland.zoek,netresearchserver,netcarta,netcraft,netmechanic,netscoop,newscan-online,nextopiabot,nhse,nitle log spider,nomad,gulliver,npbot,nutch,nzexplorer,obidos-bot,occam,sitegrabber,openfind,orb_search,overture-webcrawler,packrat,pageboy,parasite,patric,pegasus,perlcrawler,perman,petersnews,pka,phantom,piltdownman,pimptrain,pioneer,pipeliner,plumtreewebaccesor,polybot,pompos,poppi,iconoclast,pjspider,portalb,psbot,quepasacreep,raven,rbse,redalert,resumerobot,roadrunner,rhcs,robbie,robofox,francoroute,robozilla,roverbot,rules,safetynetrobot,scooter,search_au,searchprocess,searchspider,seekbot,semanticdiscovery,senrigan,sgscout,shaggy,shaihulud,sherlock-spider,shoutcast,sift,simbot,ssearcher,site-valet,sitespider,sitetech,slcrawler,slysearch,smartspider,snooper,solbot,soziopath,space bison,spanner,speedy,spiderbot,spiderline,spiderman,spiderview,spider_monkey,splatsearch.com,spry,steeler,suke,suntek,surveybot,sven,syndic8,szukacz,tach_bw,tarantula,tarspider,techbot,technoratibot,templeton,teoma_agent1,teradex,jubii,northstar,w3index,perignator,python,tkwww,webmoose,wombat,webfoot,wanderer,worm,timbobot,titan,titin,tlspider,turnitinbot,ucsd,udmsearch,ultraseek,unlost_web_crawler,urlck,vagabondo,valkyrie,victoria,visionsearch,voila,voyager,vspider,vwbot,w3m2,wmir,wapspider,appie,wallpaper,waypath scout,core,web downloader,webbandit,webbase,webcatcher,webcompass,webcopy,webcraftboot,webfetcher,webfilter,webgather,weblayers,weblinker,webmirror,webquest,webrace,webreaper,websnarf,webspider,wolp,webstripper,webtrends link analyzer,webvac,webwalk,webwalker,webwatch,wz101,wget,whatuseek,whowhere,ferret,wired-digital,wisenutbot,wwwc,xenu link sleuth,xget,cosmos,yahoo,yandex,zao,zeus,zyborg';
	</cfscript>

	<cffunction name="readSessionFromDb" access="public">
		<cfscript>
			var _urltoken = -1;
			var _sessID = -1;
			var _wddxPacket = -1;
			var _sqlStatement = -1;

			Request.isRunningOnCluster = true;
			Request.ClusterDB_DSN = 'ClusterDB';
			if (isDebugMode()) {
				Request.ClusterDB_DSN = '@ClusterDB'; // development only...
				Request.isRunningOnCluster = false;
			}
			
			bool_IsDefined_Session_sessID = IsDefined("Session.sessID");
			bool_IsDefined_URL_sessID = IsDefined("URL.sessID");
			bool_IsDefined_FORM_sessID = IsDefined("FORM.sessID");
			bool_IsDefined_Client_sessID = IsDefined("Client.sessID");
			
			_sessID = -1;
			if (bool_IsDefined_URL_sessID) {
				_sessID = URL.sessID;
			} else if (bool_IsDefined_FORM_sessID) {
				_sessID = FORM.sessID;
			} else if (bool_IsDefined_Client_sessID) {
				_sessID = Client.sessID;
			} else if (bool_IsDefined_Session_sessID) {
				_sessID = Session.sessID;
			}
		</cfscript>

		<cfscript>
			if (isDebugMode()) {
				writeOutput('<small style="font-size: 10px; color: blue;"><b>(#_sessID#) URL.sessID = [#bool_IsDefined_URL_sessID#], FORM.sessID = [#bool_IsDefined_FORM_sessID#], Client.sessID = [#bool_IsDefined_Client_sessID#], Session.sessID = [#bool_IsDefined_Session_sessID#]</b></small><br>');
			}
		</cfscript>

		<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
			<cfscript>
				_sqlStatement = "SELECT Applications.id as appID, Applications.AppName, Sessions.id AS sessID, Sessions.sessionDt, Sessions.lastAccessDt, Sessions._wddx FROM Applications INNER JOIN Sessions ON Applications.id = Sessions.appID WHERE (Sessions.id = '#_sessID#')";
				Request.commonCode.safely_execSQL('Request.qCheckSession', Request.ClusterDB_DSN, _sqlStatement);
				if (NOT Request.dbError) {
					if (Request.qCheckSession.recordCount eq 0) {	// create the session record...
						Session.sessID = -1;
	
						_sqlStatement = "SELECT id FROM Applications WHERE (AppName = '#Application.applicationname#')";
						Request.commonCode.safely_execSQL('Request.qCheckApplication', Request.ClusterDB_DSN, _sqlStatement);
						if (NOT Request.dbError) {
							if (Request.qCheckApplication.recordCount eq 0) {
								_sqlStatement = "INSERT INTO Applications (AppName) VALUES ('#Application.applicationname#'); SELECT @@IDENTITY as 'id';";
								Request.commonCode.safely_execSQL('Request.qCheckApplication', Request.ClusterDB_DSN, _sqlStatement);
							}
	
							if (NOT Request.dbError) {
								if (Request.qCheckApplication.recordCount gt 0) {
									if (NOT IsDefined("Session.persistData")) {
										Session.persistData = StructNew();
									}
									_wddxPacket = Request.commonCode.cf_wddx_CFML2WDDX(Session.persistData);
									_sqlStatement = "INSERT INTO Sessions (appID, sessionDt, lastAccessDt, _wddx) VALUES (#Request.qCheckApplication.id#,GetDate(),GetDate(),'#Request.commonCode.filterQuotesForSQL(_wddxPacket)#'); SELECT @@IDENTITY as 'id';";
									Request.commonCode.safely_execSQL('Request.qAddSession', Request.ClusterDB_DSN, _sqlStatement);
									if (NOT Request.dbError) {
										if (Request.qAddSession.recordCount gt 0) {
											Session.sessID = Request.qAddSession.id;
											Client.sessID = Session.sessID;
											Session.sessionDt = CreateODBCDateTime(Now());
											if (NOT IsDefined("Session.persistData.loginFailure")) {
												Session.persistData.loginFailure = 0;
											}
											if (NOT IsDefined("Session.persistData.loggedin")) {
												Session.persistData.loggedin = false;
											}
											if (NOT IsDefined("Session.persistData.shoppingCart")) {
												Session.persistData.shoppingCart = StructNew();
											}
											if (NOT IsDefined("Session.persistData.shoppingCart.items")) {
												Session.persistData.shoppingCart.items = 0;
											}
											Session.blogname = 'Default'; // this allows the correct blogname to be known across all servers...
										}
									} else {
										Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
									}
								}
							} else {
								Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
							}
						} else {
							Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
						}
					} else {										// read the session record...
						Session.persistData = Request.commonCode.cf_wddx_WDDX2CFML(Request.qCheckSession._wddx);
						Session.sessID = Request.qCheckSession.sessID;
						Client.sessID = Session.sessID;
						Session.sessionDt = Request.qCheckSession.sessionDt;
						if (NOT IsDefined("Session.persistData.loginFailure")) {
							Session.persistData.loginFailure = 0;
						}
						if (NOT IsDefined("Session.persistData.loggedin")) {
							Session.persistData.loggedin = false;
						}
						if (NOT IsDefined("Session.persistData.shoppingCart")) {
							Session.persistData.shoppingCart = StructNew();
						}
						if (NOT IsDefined("Session.persistData.shoppingCart.items")) {
							Session.persistData.shoppingCart.items = 0;
						}
						Session.blogname = 'Default'; // this allows the correct blogname to be known across all servers...
					}
				} else {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				}
			</cfscript>
		</cflock>
	</cffunction>

	<cffunction name="commitSessionToDb" access="public">
		
		<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
			<cfscript>
				if ( (IsDefined("Session.sessID")) AND (Session.sessID gt 0) ) {
					if (NOT IsDefined("Session.persistData")) {
						Session.persistData = StructNew();
					}

					try {
						if (StructKeyExists(Session.persistData, 'urltoken')) StructDelete(ptr, 'urltoken');
					} catch (Any e) {
					}

					_wddxPacket = Request.commonCode.cf_wddx_CFML2WDDX(Session.persistData);
					_sqlStatement = "UPDATE Sessions SET _wddx = '#Request.commonCode.filterQuotesForSQL(_wddxPacket)#', lastAccessDt = GetDate() WHERE (id = #Session.sessID#)";
					Request.commonCode.safely_execSQL('Request.qUpdateSession', Request.ClusterDB_DSN, _sqlStatement);
					if (Request.dbError) {
						Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
					}
				}

				_sqlStatement = "SELECT id FROM Sessions WHERE (lastAccessDt IS NULL) OR (DATEDIFF(minute, lastAccessDt, GETDATE()) > 90)";
				Request.commonCode.safely_execSQL('Request.qGetRetirableSessions', Request.ClusterDB_DSN, _sqlStatement);
				if (Request.dbError) {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				} else {
					ar_retireableSessions = ArrayNew(1);
					for (i = 1; i lte Request.qGetRetirableSessions.recordCount; i = i + 1) {
						ar_retireableSessions[ArrayLen(ar_retireableSessions) + 1] = Request.qGetRetirableSessions.id[i];
					}
					_retireableSessions = ArrayToList(ar_retireableSessions, ',');
					
					if (ListLen(_retireableSessions, ',') gt 0) {
						_sqlStatement = "DELETE FROM tblUsersSession WHERE (sessID in (#_retireableSessions#))";
						Request.commonCode.safely_execSQL('Request.qRetireUserSessions', application.blog.instance.dsn, _sqlStatement);
						if (Request.dbError) {
							Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
						}
					}
				}

				_sqlStatement = "DELETE FROM Sessions WHERE (lastAccessDt IS NULL) OR (DATEDIFF(minute, lastAccessDt, GETDATE()) > 90)";
				Request.commonCode.safely_execSQL('Request.qRetireSessions', Request.ClusterDB_DSN, _sqlStatement);
				if (Request.dbError) {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				}

				_isloggedin = 0;
				_uid = -1;
				try {
					if (session.persistData.loggedin) {
						_isloggedin = 1;
						_uid = Session.persistData.qauthuser.id;
					}
				} catch (Any e) {
				}
				_sqlStatement = "INSERT INTO tblUsersActivities (uid, sessID, isloggedin, today, script_name, http_referrer, query_string) VALUES (#_uid#, #Session.sessID#, #_isloggedin#, GetDate(),'#Request.commonCode.filterQuotesForSQL(CGI.SCRIPT_NAME)#','#Request.commonCode.filterQuotesForSQL(CGI.HTTP_REFERER)#','#Request.commonCode.filterQuotesForSQL(URLDecode(CGI.QUERY_STRING))#'); SELECT @@IDENTITY as 'id';";
				Request.commonCode.safely_execSQL('Request.qLogUsersActivities', application.blog.instance.dsn, _sqlStatement);
				if (Request.dbError) {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				}
			</cfscript>
		</cflock>

	</cffunction>

	<cfscript>
		function _clusterizeURL(_url) {
			var aa = -1;
			var pa = -1;
			var a = ListToArray(_url, "/");
			var p = ArrayToList(a, "/");
			if ( (UCASE(a[1]) eq "HTTP:") OR (UCASE(a[1]) eq "HTTPS:") ) {
				p = ListDeleteAt(p, 1, "/");
			}
			if ( (UCASE(a[2]) eq UCASE(CGI.SERVER_NAME)) AND (CGI.SERVER_PORT neq "80") ) {
				p = ListSetAt(p, 1, CGI.SERVER_NAME & ":" & CGI.SERVER_PORT, "/");
			}
			// BEGIN: Ensure the Cluster Manager's Domain is the one being hit by this link...
			aa = ListToArray(ListGetAt(p, 1, '/'), '.');
			pa = ArrayToList(aa, '.');
			if (ArrayLen(aa) eq 4) {
				pa = ListDeleteAt(pa, 2, '.');
			}
			// END! Ensure the Cluster Manager's Domain is the one being hit by this link...
			p = ListSetAt(p, 1, pa, "/");
			return p;
		}
		
		function clusterizeURL(_url) {
			return "http://" & _clusterizeURL(_url);
		}
		
		function _clusterizeURLForSessionOnly(_url) {
			var newURL = _url;
			if (IsDefined("Session.sessID")) {
				if (FindNoCase('.cfm', newURL) gt 0) {
					newURL = newURL & '?sessID=#Session.sessID#';
				} else {
					newURL = newURL & '/#Session.sessID#/';
				}
			}
			return newURL;
		}
		
		function clusterizeURLForSessionOnly(_url) {
			var newURL = clusterizeURL(_url);
			return _clusterizeURLForSessionOnly(newURL);
		}

		function getClusterizedDomainFromReferrer(aURL) {
			var i = -1;
			var ar = ListToArray(aURL, '/');
			var n = ArrayLen(ar);
			for (i = 1; i lte n; i = i + 1) {
				if (ListLen(ar[i], '.') gte 2) {
					return _clusterizeURL('http://' & ar[i]);
				}
			}
			return '';
		}
				
		function makeLinkToSelf(aURL, isMakingLink) {
			var myPrefix = CGI.SCRIPT_NAME;
			if (NOT IsBoolean(isMakingLink)) {
				isMakingLink = false;
			}
			if (NOT isMakingLink) {
				myPrefix = ListDeleteAt(myPrefix, ListLen(myPrefix, '/'), '/');
			}
			return clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME##myPrefix#/#aURL#');
		}

		function makeLinkToSelfBase(aURL) {
			var myPrefix = ListFirst(CGI.SCRIPT_NAME, '/');
			return clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#/#myPrefix#/#aURL#');
		}

		function isSpiderBot() {
			var i = -1;
			var n = -1;
			var bool_isSpiderBot = false;
			var ar_bots = ListToArray(this.bots_list, ',');
			
			if (Len(Trim(CGI.HTTP_REFERER)) eq 0) {
				n = ArrayLen(ar_bots);
				for (i = 1; i lte n; i = i + 1) {
					if (FindNoCase(ar_bots[i], CGI.HTTP_USER_AGENT) gt 0) {
						bool_isSpiderBot = true;
						break;
					}
				}
			}
			return bool_isSpiderBot;
		}
		
	</cfscript>
</cfcomponent>
