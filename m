Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34341 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3HAVxi (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Aug 2013 17:53:38 -0400
Received: by mail-pb0-f52.google.com with SMTP id wz12so2556213pbc.25
        for <fio@vger.kernel.org>; Thu, 01 Aug 2013 14:53:37 -0700 (PDT)
Message-ID: <1375393883.30810.44.camel@espiritosanto.int.convergent.io>
Subject: Memorized block verification headers.
From: Daniel Stodden <daniel@convergent.io>
Date: Thu, 01 Aug 2013 14:51:23 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


Hi.

Worrying about stale data reads, i.e. no internal corruption, but
storage reading back data which was confirmed as rewritten.

Here's a relatively simple patch to annotate the iolog with checksums
for verification.

I patched this into fio-2.0.11, and for now it's more of an rfc than
calling for inclusion.

Some things I've been wondering about:

 * Metadata mode is nice for debugging.
   
   Currently, metadata writes disable checksumming, which
   weakens integrity checks.

   So I'm wondering if the two shouldn't rather have nested.

 * This (s/w obviously) won't work with async verification:
   collisions between verify reads and generated re-writes
   are not tracked. 

   I guess one could consider letting async mode 
   consume an rbtree'd block map, maybe add generation ids to
   the block headers, and detect collisions.

 * Requires additional host memory, according to backlog size. 
   Didn't add an option turn it on/off yet.

More thoughts?

Thanks,
Daniel

