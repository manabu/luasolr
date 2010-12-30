#!/bin/usr/lua

require('luasolr')

function search(id)
   local search_doc ={}
   search_doc.id=id
   local obj = luasolr.search(search_doc)
   if #obj.response.docs > 0 then
      print("found id=["..id.."]")
      print(obj.response.docs[1].id)
      print(obj.response.docs[1].price)
   else
      print("not found id=["..id.."]")
   end
end


-- set url
-- luasolr.setHostUrl("http://localhost:8983/solr")

-- add
print("--- add")
local docs = {}
local doc ={}
doc.id='solrtest101'
doc.price=4111
table.insert(docs, doc)

luasolr.add(docs)

-- search
print("--- search after add")
search("solrtest101")

-- update
print("--- update")
local docs2 = {}
local doc2 ={}
doc2.id='solrtest101'
doc2.price=4121
table.insert(docs2, doc2)

luasolr.add(docs2)

-- search after update
print("--- search after update")
search("solrtest101")

-- delete
print("--- delete")
local docs3 = {}
local doc3 ={}
doc3.id='solrtest101'
table.insert(docs3, doc3)

luasolr.delete(docs3)


-- search after delete
print("--- search after delete")
search("solrtest101")

-- search after delete
print("--- search for no such id")
search("no_such_id_document")


-- search after delete with escape
print("--- search for no such id")
search("no such id document")

