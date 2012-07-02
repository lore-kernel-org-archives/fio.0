Return-Path: <fio-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:36913 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab2GBTMw (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 2 Jul 2012 15:12:52 -0400
Received: from zion.americas.sgi.com (zion.americas.sgi.com [128.162.236.17])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46B4C8F8073
	for <fio@vger.kernel.org>; Mon,  2 Jul 2012 12:12:52 -0700 (PDT)
Received: (from emery@localhost) by zion.americas.sgi.com (8.12.9/ASC-news-1.4) id q62JCqDV26291886 for fio@vger.kernel.org; Mon, 2 Jul 2012 14:12:52 -0500 (CDT)
Date: Mon, 2 Jul 2012 14:12:52 -0500 (CDT)
From: Scott Emery <emery@sgi.com>
Message-Id: <201207021912.q62JCqDV26291886@zion.americas.sgi.com>
Subject: Client - Server(s?)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


Hullo Jens,
	I have enjoyed using fio, I find it to be easy to set up and
run. 

	I have a question about the direction of client/server, which
revolves around a situation I would like to benchmark.  I deal with
a couple of clustered filesystems and would like to get aggregate
performance values based on I/O from multiple filesystem clients.
To that end I would like to drive a test from a single "location" to
multiple filesystem clients. 

	My understanding (?) of fio client/server semantics is that
one client drives no more than one server.  With this understanding
I would set up a fio server on each filesystem client that I want  to
test and then run fio clients from my test location in parallel to
each fio server/filesystem client.  I would then aggregate the
statistics by hand.   This is certainly a huge step up from scripting
something myself by hand. 

	It would be convenient if I could have one client/set of clients
work together to drive the fio servers and aggregate the statistics
for me.  Is this where fio is going?

Scott Emery
emery@sgi.com
