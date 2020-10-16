<cfcomponent displayname="geonosisMetadata" output="Yes" extends="geonosisCode">

	<cfscript>
		this.DSN = '';
		this.qGeonosisObjectClassMetaData = '';
		this.qGeonosisObjectsMetaData = '';
		this.qGeonosisObjectAttributesMetaData = '';
		this.qGeonosisObjectLinksMetaData = '';
		
		function init(sDSN) {
			super.init(sDSN);
			this.DSN = sDSN;
			return this;
		}
		
		function getGeonosisObjectClassMetaData() {
			safely_execSQL('this.qGeonosisObjectClassMetaData', this.DSN, sql_GeonosisObjectClassMetaData());
			if ( (Request.dbError) OR (NOT IsQuery(this.qGeonosisObjectClassMetaData)) ) {
				this.qGeonosisObjectClassMetaData = -1;
			}
			return this;
		}

		function getGeonosisObjectsMetaData() {
			safely_execSQL('this.qGeonosisObjectsMetaData', this.DSN, sql_GeonosisObjectsMetaData());
			if ( (Request.dbError) OR (NOT IsQuery(this.qGeonosisObjectsMetaData)) ) {
				this.qGeonosisObjectsMetaData = -1;
			}
			return this;
		}

		function getGeonosisObjectAttributesMetaData() {
			safely_execSQL('this.qGeonosisObjectAttributesMetaData', this.DSN, sql_GeonosisObjectAttributesMetaData());
			if ( (Request.dbError) OR (NOT IsQuery(this.qGeonosisObjectAttributesMetaData)) ) {
				this.qGeonosisObjectAttributesMetaData = -1;
			}
			return this;
		}

		function getGeonosisObjectLinksMetaData() {
			safely_execSQL('this.qGeonosisObjectLinksMetaData', this.DSN, sql_GeonosisObjectLinksMetaData());
			if ( (Request.dbError) OR (NOT IsQuery(this.qGeonosisObjectLinksMetaData)) ) {
				this.qGeonosisObjectLinksMetaData = -1;
			}
			return this;
		}
	</cfscript>
</cfcomponent>
