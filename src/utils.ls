#* Module utils
#
# Utilities for generating Tab/Group artifacts
#
#
# Copyright (c) 2012 Quildreen Motta
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


module.exports = (engine) ->

  
  ### -- Dependencies --------------------------------------------------
  {Tab, Group}                             = require './core'
  {query, map, add-class, has-class, head} = (require 'doom') engine
  {target}                                 = (require 'jsk-togglable/lib/utils') engine


  
  ### -- Helpers -------------------------------------------------------
  mark-as-processed     = add-class \jskp-tabgroup
  filter = (f, xs) --> [].filter.call xs, f

  #### λ find-anchors
  # Selects nodes that can be used as toggling anchors for a context
  # node `x`.
  #
  # :: Node -> [Node]
  find-anchors = (x) -> query 'a.jsk-anchor[href*="#"], .tab[data-jsk-target]' x

  current-p       = (tab) -> ~(tab.tab.href.indexOf location.hash)
  active-p        = (tab) -> (current-p tab) || (has-class-p \active tab.tab).0
  find-active-tab = (tabs) -> (head . filter active-p) tabs
  active-tab      = (tabs) -> (find-active-tab tabs) || (head tabs)

  
  ### -- Core implementation -------------------------------------------

  make-tabs = (group, xs) --> xs |> map ->
    Tab.make group, it, target it


  make-groups = (parent, xs) --> xs |> map ->
    mark-as-processed it
    group = Group.make parent
    tabs  = make-tabs group, find-anchors it
    (active-tab tabs).show!
    group


  
  ### -- Exports -------------------------------------------------------
  { make-tabs, make-groups }
