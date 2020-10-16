<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (c) 1995-2005 Macromedia, Inc. All rights reserved. -->
<!--
Sample javascript output. generated by CFFORM
**************************************************************
<script language="JavaScript" type="text/javascript" src="/CFIDE/scripts/cfform.js"/>
<script language="JavaScript" type="text/javascript">
    function  _CF_checkCFForm_1(_CF_this)
    {
        //reset on submit
        _CF_error_messages = new Array();
        _CF_error_fields = new Object();
        _CF_FirstErrorField = null;

        //form element firstName required check
        if( _CF_hasValue(_CF_this['firstName'], "TEXT", false ) )
        {
            //form element firstName 'TELEPHONE' validation checks
            if (!_CF_checkphone(_CF_this['firstName'].value))
            {
                _CF_onError(_CF_this, "firstName", _CF_this['firstName'].value, "error in first name!!");
            }
        }

        //display error messages and return success
        if( _CF_error_messages.length > 0 )
        {
            // show alert() message
            _CF_onErrorAlert(_CF_error_messages);
            // set focus to first form error, if the field supports js focus().
            if( _CF_this[_CF_FirstErrorField].type == "text" )
            { _CF_this[_CF_FirstErrorField].focus(); }

            return false;
        }else {
            return true;
        }
    }
</script>	
**************************************************************
-->
<xsl:stylesheet version="1.0" 
	xmlns:xsi = "http://www.w3.org/1999/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xf="http://www.w3.org/2002/xforms" 
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cf="http://www.macromedia.com/2004/cfform"  
	exclude-result-prefixes="xsi xsl xf html cf"
>

	<xsl:template name="getMessage">
		<xsl:choose>
			<xsl:when test="xf:extension/cf:attribute/@name = 'message' ">
				<xsl:value-of  select="xf:extension/cf:attribute[@name = 'message' ]/text()"/>
			</xsl:when>
			<xsl:when test="xf:extension/cf:validate/cf:argument[@name='message']">
				<xsl:value-of  select="xf:extension/cf:validate/cf:argument[@name='message']/text()"/>
			</xsl:when>
			<xsl:when test="cf:argument/@name = 'message' ">
				<xsl:value-of  select="cf:argument[@name = 'message' ]/text()"/>
			</xsl:when>
			<xsl:when test="@id ">
				<!-- default required error message -->
				<xsl:text>Error in </xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text> field.</xsl:text>
			</xsl:when>
			<xsl:when test="parent::*/parent::*/@id">
				<!-- default required error message -->
				<xsl:text>Error in </xsl:text>
				<xsl:value-of select="parent::*/parent::*/@id"/>									<xsl:text> field.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- default catch all message -->
					<xsl:text>Error in field.</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
 	</xsl:template>
 	
 	<xsl:template name="getHiddenMessage">
		<xsl:choose>
			<xsl:when test="cf:argument/@name = 'message' ">
				<xsl:value-of  select="cf:argument[@name = 'message' ]/text()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="text()"/>
			</xsl:otherwise>
		</xsl:choose>
 	</xsl:template>
 	


<!-- **************************************************************************************************
	*	Server Side / Hidden Field Validation
	************************************************************************************************** -->
	
	<!-- loop over each item in hte model that doesn't have a form element with a matching @id -->
	<xsl:template name="onServerValidation">
		<xsl:for-each select="//form/xf:model/xf:instance/cf:data/*[not(name() =  //form/descendant::*/@id)]">
			<xsl:call-template name="hidden"></xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="hidden">
		<xsl:element name="div">
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>

			<xsl:choose>
				<xsl:when test="text()">
					<xsl:attribute name="value">
						<xsl:call-template name="getHiddenMessage"/>
					</xsl:attribute>
				</xsl:when>
                <xsl:when test="contains(name(), '_CFFORM')">
                    <!-- default error message -->
					<xsl:attribute name="value">
						<xsl:text>Error in </xsl:text>
						<xsl:value-of select="substring-before(name(), '_')"/>
						<xsl:text> field.</xsl:text>
					</xsl:attribute>
                </xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</xsl:element>
	</xsl:template>

	

<!-- **************************************************************************************************
	*	onSubmit Validation
	************************************************************************************************** -->

	<xsl:template name="onSubmitValidation">
		<xsl:variable name="formName" select="//form/@cf:name"/>
		<xsl:variable name="scriptSrc" select="//form/@cf:scriptsrc"/>
		<!-- include cfform.js file -->
		<xsl:element name="script">
			<xsl:attribute name="type">text/javascript</xsl:attribute>
			<xsl:attribute name="src">
				<xsl:value-of select="concat($scriptSrc, 'cfform.js')"/>
			</xsl:attribute>
			<xsl:text> </xsl:text>
		</xsl:element>
		<!-- output custom block of calls to the cfform.js file, these are just the calls required to validate this file -->
		<xsl:element name="script">
			<xsl:attribute name="type">text/javascript</xsl:attribute>
				
<xsl:text disable-output-escaping="yes">
	function </xsl:text><xsl:value-of select="concat('_CF_check', $formName)"/><xsl:text>(_CF_this)
	{
	        //reset on submit
	        _CF_error_messages = new Array();
	        _CF_error_fields = new Object();
	        _CF_FirstErrorField = null;
</xsl:text>

<xsl:for-each select="//form/xf:model/xf:bind">
	<xsl:call-template name="getOnSubmitJavascript"/>
</xsl:for-each>

<xsl:text disable-output-escaping="yes">	
        //display error messages and return success
        if( _CF_error_messages.length > 0 )
        {
            // show alert() message
            _CF_onErrorAlert(_CF_error_messages);
            // set focus to first form error, if the field supports js focus().
            if( _CF_this[_CF_FirstErrorField].type == "text" )
            { _CF_this[_CF_FirstErrorField].focus(); }

            return false;
        }else {
            return true;
        }
}
</xsl:text>
		</xsl:element>	
	</xsl:template>
	
	<xsl:template name="getOnSubmitJavascript">
		<xsl:variable name="name" select="@id" />
		<xsl:variable name="required" select="@required"/> 
		<xsl:variable name="onError" select="xf:extension/cf:attribute[@name='onerror']/text()"/>



		
		<!-- only work with bind elements that have a cf:type attribute, ignoring the NOBLANKS type (this is used in hte required check) -->


		<!-- wrap validation call in required check, if needed -->
		<xsl:if test="$required = 'true()'">
			<xsl:text>
				if( _CF_hasValue(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'], "</xsl:text><xsl:value-of select="xf:extension/cf:attribute[@name='type']/text()"/><xsl:text>", </xsl:text>
				<xsl:choose>
					<xsl:when test="xf:extension/cf:validate[@type = 'noblanks']">
						<xsl:text>true</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>false</xsl:text>
					</xsl:otherwise>
				</xsl:choose>		
				<xsl:text> ) )
			       {	
			</xsl:text>	
		</xsl:if>
		
		<xsl:for-each select="xf:extension/cf:validate">
			<xsl:if test="cf:trigger[@event = 'onsubmit']">
				
				<xsl:choose>
					<xsl:when test="@type='boolean'">
						<xsl:text>
					            if (!_CF_checkBoolean(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>			
					</xsl:when>
					<xsl:when test="@type='creditcard'">
						<xsl:text>
					            if (!_CF_checkcreditcard(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");	            
							}
						</xsl:text>			
					</xsl:when>
					<xsl:when test="@type='date'">
						<xsl:text>
					            if (!_CF_checkdate(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>			
					</xsl:when>
					<xsl:when test="@type='usdate'">
						<xsl:text>
					            if (!_CF_checkdate(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>						
					</xsl:when>
					<xsl:when test="@type='email'">
						<xsl:text>
					            if (!_CF_checkEmail(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='eurodate'">
						<xsl:text>
					            if (!_CF_checkeurodate(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='float'">
						<xsl:text>
					            if (!_CF_checknumber(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='guid'">
						<xsl:text>
					            if (!_CF_checkGUID(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='integer'">
						<xsl:text>
					            if (!_CF_checkinteger(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='numeric'">
						<xsl:text>
					            if (!_CF_checknumber(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='maxlength'">
					
					</xsl:when>
					<xsl:when test="@type='range'">
						
					</xsl:when>
					<xsl:when test="@type='regex'">
						<xsl:text>
					            if (!_CF_checkregex(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            			<xsl:text>/</xsl:text>
<xsl:value-of select="cf:argument[@name='pattern']"/><xsl:text>/,</xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='regular_expression'">
						<xsl:text>
					            if (!_CF_checkregex(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='ssn'">
						<xsl:text>
					            if (!_CF_checkssn(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='social_security_number'">
						<xsl:text>
					            if (!_CF_checkssn(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='telephone'">
						<xsl:text>
					            if (!_CF_checkphone(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='time'">
						<xsl:text>
					            if (!_CF_checktime(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='url'">
						<xsl:text>
					            if (!_CF_checkURL(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='uuid'">
						<xsl:text>
					            if (!_CF_checkUUID(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='zipcode'">
						<xsl:text>
					            if (!_CF_checkzip(_CF_this['</xsl:text><xsl:value-of select="$name"/><xsl:text>'].value, </xsl:text>
					            		<xsl:choose>
									<xsl:when test="@required='true()'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>					            
					            <xsl:text>))
					            {
					                </xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="$name"/><xsl:text>",  _CF_this['</xsl:text>
					                		<xsl:value-of select="$name"/><xsl:text>'].value,"</xsl:text>
					                		<xsl:call-template name="getMessage" /><xsl:text>");
					            }
						</xsl:text>
					</xsl:when>
					<xsl:when test="@type='submitonce'">
					
					</xsl:when>
				</xsl:choose>

			</xsl:if>
		</xsl:for-each>

		
		<xsl:if test="$required = 'true()'">
			<xsl:text>
				}else {
		            		</xsl:text><xsl:value-of select="$onError"/><xsl:text>(_CF_this, "</xsl:text><xsl:value-of select="@id"/><xsl:text>", _CF_this['</xsl:text><xsl:value-of select="@id"/><xsl:text>'].value, "</xsl:text><xsl:call-template name="getMessage" /><xsl:text>");
		        	}
			</xsl:text>	
		</xsl:if>
	
	</xsl:template>

	
	
	
	
	
	
	
	
<!-- **************************************************************************************************
	*	onBlur Validation
	************************************************************************************************** -->	
	<xsl:template name="onBlurValidation">
		<xsl:for-each select="xf:extension/cf:validate">
			<xsl:if test="cf:trigger[@event = 'onblur']">
				<xsl:call-template name="getOnBlurJavaScript"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="getOnBlurJavaScript">
		<xsl:variable name="name" select="parent::*/parent::*/@id" />
		<xsl:variable name="required" select="parent::*/parent::*/@required"/>       


		<xsl:choose>
			<xsl:when test="@type = 'boolean'">
  		       <xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkBoolean(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'creditcard'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkcreditcard(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'date'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkdate(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'email'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkEmail(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'eurodate'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkeurodate(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'float'">
			<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checknumber(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'guid'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkGUID(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'integer'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkinteger(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'maxlength'"></xsl:when>
			<xsl:when test="@type = 'numeric'">
			<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checknumber(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'range'"></xsl:when>								
			<xsl:when test="@type = 'regex'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkregex(this.value, </xsl:text>
					<xsl:text>/</xsl:text>
<xsl:value-of select="cf:argument[@name='pattern']"/><xsl:text>/,</xsl:text>

		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'regular_expression'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkregex(this.value, </xsl:text>
					<xsl:text>/</xsl:text>
<xsl:value-of select="cf:argument[@name='pattern']"/><xsl:text>/,</xsl:text>

		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'required'"></xsl:when>
			<xsl:when test="@type = 'ssn'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkssn(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'social_security_number'">
            		<xsl:attribute name="onBlur">
				<xsl:text>if (!_CF_checkssn(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>				
				<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
					<xsl:call-template name="getMessage" />
				<xsl:text>')); }</xsl:text>
			</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'telephone'">
            		<xsl:attribute name="onBlur">
                		<xsl:text>if (!_CF_checkphone(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>                		
                		<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
                    		<xsl:call-template name="getMessage" />
                		<xsl:text>')); }</xsl:text>
            		</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'time'">
            		<xsl:attribute name="onBlur">
                		<xsl:text>if (!_CF_checktime(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>                		
                		<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
                    		<xsl:call-template name="getMessage" />
                		<xsl:text>')); }</xsl:text>
            		</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'url'">
            		<xsl:attribute name="onBlur">
                		<xsl:text>if (!_CF_checkURL(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>                		
                		<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
                    		<xsl:call-template name="getMessage" />
                		<xsl:text>')); }</xsl:text>
            		</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'uuid'">
            		<xsl:attribute name="onBlur">
                		<xsl:text>if (!_CF_checkUUID(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>                		
                		<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
                    		<xsl:call-template name="getMessage" />
                		<xsl:text>')); }</xsl:text>
            		</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'usdate'">
            		<xsl:attribute name="onBlur">
                		<xsl:text>if (!_CF_checkdate(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>                		
                		<xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
                    		<xsl:call-template name="getMessage" />
                		<xsl:text>')); }</xsl:text>
            		</xsl:attribute>
			</xsl:when>
			<xsl:when test="@type = 'zipcode'">
			<xsl:attribute name="onBlur">
	                <xsl:text>if (!_CF_checkzip(this.value, </xsl:text>
		            		<xsl:choose>
						<xsl:when test="@required='true()'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>	                
	                <xsl:text>)){ _CF_onErrorAlert(new Array('</xsl:text>
	                    	<xsl:call-template name="getMessage" />
	                <xsl:text>')); }</xsl:text>
	            	</xsl:attribute>
			</xsl:when>
		</xsl:choose>			
	</xsl:template>
</xsl:stylesheet>
