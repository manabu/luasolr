module("luasolr",package.seeall)

local json = require("json")
local io = require("io")
local http = require("socket.http")
local ltn12 = require("ltn12")
local lom = require("lxp.lom")

local host = "http://localhost:8983/solr"

function setHostUrl(url)
   host = url
end

function add(docs)
   local url = host.."/update?wt=json&commit=true"
   local xml = toXML_docs(docs)
   local chunk = {}

   local b,c = http.request{
      method = "POST",
      url = url,
      headers = {
         ["content-length"] = #xml,
         ["Content-Type"] =  "text/xml"
      },
      source = ltn12.source.string(xml),
      sink = ltn12.sink.table(chunk)
   }
end

function toXML_docs(docs)
   local docs2=docs
   local xml =
[[
<?xml version="1.0" encoding="ISO-8859-1"?>
<add>
]]
   for k,v in pairs(docs2) do
      xml=xml..addXML(v)
   end
   xml = xml.."</add>"
   return xml
end

function addXML(doc)
   local val = "<doc>"

   for k,v in pairs(doc) do
      val = val .."<field name=\""..k.."\">"..tostring(v).."</field>"
   end
   val = val.."</doc>"
   return val
end

function delete(docs)
   local url = host.."/update?wt=json&commit=true"
   local xml = delete_docs_XML(docs)
   local chunk = {}

   local b,c = http.request{
      method = "POST",
      url = url,
      headers = {
         ["content-length"] = #xml,
         ["Content-Type"] =  "text/xml"
      },
      source = ltn12.source.string(xml),
      sink = ltn12.sink.table(chunk)
   }
end

function delete_docs_XML(docs)
   local docs2=docs
   local xml =
[[
<?xml version="1.0" encoding="ISO-8859-1"?>
<delete>
]]
   for k,v in pairs(docs2) do
      xml=xml..deleteXML(v)
   end
   xml = xml.."</delete>"
   return xml
end

function deleteXML(doc)
   local val = "<query>"

   for k,v in pairs(doc) do
      val = val ..k..":"..tostring(v)
   end
   val = val.."</query>"
   return val
end


function search(doc)
   local url = host.."/select?wt=json&q="
   local xml = search_doc(doc)
   url = url..xml
   local chunk = {}

   local b,c = http.request{
      method = "GET",
      url = url,
      headers = {
         ["Content-Type"] =  "text/plain"
      },
      sink = ltn12.sink.table(chunk)
   }
   local resultJson = table.concat(chunk)
   return json.decode(resultJson)
end

function search_doc(doc)
   local val = "("

   for k,v in pairs(doc) do
      val = val ..k..":"..tostring(v)
   end
   val = val..")"
   return val
end
