<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfif not listFind("Portal,Gallery",$.content('type'))>
<cfsilent>
<cfset $.loadJSLib() />
<cfswitch expression="#$.getJsLib()#">
	<cfcase value="jquery">
	 	<cfset $.addToHTMLHeadQueue("rater/htmlhead/rater-jquery.cfm")>
	</cfcase>
	<cfdefaultcase>
		<cfset $.addToHTMLHeadQueue("rater/htmlhead/rater-prototype.cfm")>
	</cfdefaultcase>
	</cfswitch>
<cfset $.addToHTMLHeadQueue("rater/htmlhead/rater.cfm")>

<cfif not isNumeric($.event('rate'))>
	<cfset $.event('rate',0)>
</cfif>

<cfset $.event('raterID',$.getPersonalizationID()) />
<cfif listFind($.event('doaction'),"saveRate") and $.event('raterID') neq ''>
	<cfset myRate=$.getBean('raterManager').saveRate(
	$.content('contentID'),
	$.event('siteID'),
	$.event('raterID'),
	$.event('rate')) />
<cfelse>
	<cfset myRate = $.getBean('raterManager').readRate(
	$.content('contentID'),
	$.content('siteID'),
	$.event('raterID')) />
</cfif>
<cfset rsRating=$.getBean('raterManager').getAvgRating($.content('contentID'),$.content('siteID')) />

</cfsilent>
<cfoutput>
<div id="svRatings" class="clearfix">	
	<div id="rateIt">
	<#$.getHeaderTag('subHead1')#>#$.rbKey('rater.ratethis')#</#$.getHeaderTag('subHead1')#>				
		<form name="rater1" id="rater1" method="post" action="">
			<input type="hidden" id="rate" name="rate" value="##">
			<input type="hidden" id="userID" name="userID" value="#$.event('raterID')#">
			<input type="hidden" id="loginURL" name="loginURL" value="#$.siteConfig('loginURL')#&returnURL=#URLencodedFormat($.getCurrentURL(true,'doaction=saveRate&rate='))#">
			<input type="hidden" id="siteID" name="siteID" value="#$.event('siteID')#">
			<input type="hidden" id="contentID" name="contentID" value="#$.content('contentID')#">
			<input type="hidden" id="formID" name="formID" value="rater1">
			<fieldset>
				<label for="rater1_rater_input0radio1"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio1" value="1" class="stars" <cfif myRate.getRate() eq 1>checked</cfif> >Not at All</label>
				<label for="rater1_rater_input0radio2"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio2" value="2" class="stars"  <cfif myRate.getRate() eq 2>checked</cfif>>Somewhat</label>
				<label for="rater1_rater_input0radio3"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio3" value="3" class="stars" <cfif myRate.getRate() eq 3>checked</cfif>>Moderately</label>
				<label for="rater1_rater_input0radio4"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio4" value="4" class="stars" <cfif myRate.getRate() eq 4>checked</cfif> >Highly</label>
				<label for="rater1_rater_input0radio5"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio5" value="5" class="stars" <cfif myRate.getRate() eq 5>checked</cfif>>Very Highly</label>
				<!---<input type="submit" value="rate it" class="submit">--->
			</fieldset>
		</form>									
	</div>
	
	<div id="avgrating">
		<cfif rsRating.theCount gt 0>
			<#$.getHeaderTag('subHead1')#>#$.rbKey('rater.avgrating')# (<span id="numvotes">#rsRating.theCount# <cfif rsRating.theCount neq 1>#$.rbKey('rater.votes')#<cfelse>#$.rbKey('rater.vote')#</cfif></span>)</#$.getHeaderTag('subHead1')#>
			<div id="avgratingstars" class="ratestars #$.getBean('raterManager').getStarText(rsRating.theAvg)#<!--- #replace(rsRating.theAvg(),".","")# --->">
			<cfif isNumeric(rsRating.theAvg)>#rsRating.theAvg#<cfelse>0</cfif>
			<!--- <img id="ratestars" src="#event.getSite().getAssetPath()#/images/rater/star_#application.raterManager.getStarText(rsRating.theAvg)#.gif" alt="<cfif isNumeric(rsRating.theAvg)>#rsRating.theAvg# star<cfif rsRating.theAvg gt 1>s</cfif></cfif>" border="0"> ---></div>
		</cfif>
		<script type="text/javascript">
		  initRatings('rater1');
		</script>
	</div>
</div>		
</cfoutput>
</cfif>