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

<cfsilent>
	<cfif isValid("UUID",arguments.objectID)>
		<cfset bean = $.getBean("content").loadBy(contentID=arguments.objectID,siteID=arguments.siteID)>
	<cfelse>
		<cfset bean = $.getBean("content").loadBy(title=arguments.objectID,siteID=arguments.siteID)>
	</cfif>
	<cfset rsForm=bean.getAllValues()>
	<cfset event.setValue("formBean",bean)>
	
	<cfset rsForm.isOnDisplay=rsForm.display eq 1 or 
			(
				rsForm.display eq 2 and rsForm.DisplayStart lte now()
				AND (rsForm.DisplayStop gte now() or rsForm.DisplayStop eq "")
			)>
</cfsilent>
<cfoutput>
<cfif rsForm.isOnDisplay>
	<cfif rsForm.displayTitle neq 0><#$.getHeaderTag('subHead1')#>#rsForm.title#</#$.getHeaderTag('subHead1')#></cfif>
	<cfif isdefined('request.formid') and request.formid eq rsform.contentid>
	<cfset acceptdata=1> 
	<cfinclude template="act_add.cfm">
	<cfinclude template="dsp_response.cfm">
	<cfelse>
	<cfsilent>
		<cfif isJSON(rsForm.body)>
			<cfset renderedForm=$.setDynamicContent(
					dspObject_Include(
						thefile='formbuilder/dsp_form.cfm',
						formid=rsForm.contentid,
						siteid=rsForm.siteid,
						formJSON=rsForm.body
					)
				)>
		<cfelse>
			<cfset renderedForm=$.setDynamicContent(rsForm.body)>
		</cfif>
		</cfsilent>
		<cfset renderedForm=application.dataCollectionManager.renderForm(
			rsForm.contentid,
			$.event('siteID'),
			renderedForm,
			rsForm.responseChart, 
			$.content('contentID')
		)>
		#renderedForm#
		<cfif find("htmlEditor",renderedForm)>
			<cfset $.addToHTMLHeadQueue("htmlEditor.cfm")>	
			<script type="text/javascript">
			setHTMLEditors(200,500);
			</script>
		</cfif>
	</cfif>
</cfif>
</cfoutput>
<cfif rsForm.isOnDisplay and rsForm.forceSSL eq 1>
<cfset request.forceSSL = 1>
<cfset request.cacheItem=false>
<cfelse>
<cfset request.cacheItem=rsForm.doCache>
</cfif>