Return-Path: <fio-owner@vger.kernel.org>
Received: from mta01.ornl.gov ([128.219.177.14]:63138 "EHLO mta01.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003AbbCDDuO convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 3 Mar 2015 22:50:14 -0500
Received: from EXCHOS32.ornl.gov (exchos32.ornl.gov [128.219.12.152])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by emgwy2.ornl.gov (Postfix) with ESMTPS id 8A962E06A5
	for <fio@vger.kernel.org>; Tue,  3 Mar 2015 22:40:23 -0500 (EST)
From: "Caldwell, Blake A." <blakec@ornl.gov>
Subject: Missing completions with libaio after context switch?
Date: Wed, 4 Mar 2015 03:40:21 +0000
Message-ID: <C907C3B4-6C98-4E1E-A363-0F3C110BF2E1@ornl.gov>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9713502F0C7F9F4996785C3DD6CA6652@ornl.gov>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

While looking at fio activity with libaio using blktrace, I could not find completion requests when fio is rescheduled onto a different CPU. For instance, in the trace below the IO stream to /dev/sdae is moved from CPU 8 to CPU 10 and there is no corresponding completion (or insertion) for a get request at offset 5743016.  It would seem that fio was preempted before fully forming the request (Q and G, but no I or D). Is this expected behavior?

fio version 2_1_4 from http://git.kernel.dk/fio.git

fio --bs=4k --ioengine=libaio --rw=write --iodepth=127 --buffered=0 --norandommap --thread --loops=2147483648 --runtime=60 --gtod_reduce=1 --invalidate=1 --name=/dev/sdae --filename=/dev/sdae

 65,224  8    84946     0.228857464  9729  C  WS 5742888 + 8 [0]
 65,224  8    84947     0.228858948  9729  C  WS 5742896 + 8 [0]
 65,224  8    84948     0.228861434  9729  C  WS 5742904 + 8 [0]
 65,224  8    84949     0.228862696  9729  C  WS 5742912 + 8 [0]
 65,224  8    84950     0.228863825  9729  C  WS 5742920 + 8 [0]
...
 65,224  8    84966     0.228883226  9729  Q  WS 5743008 + 8 [fio]
 65,224  8    84967     0.228883518  9729  G  WS 5743008 + 8 [fio]
 65,224  8    84968     0.228883783  9729  I  WS 5743008 + 8 [fio]
 65,224  8    84969     0.228884001  9729  D  WS 5743008 + 8 [fio]
 65,224  8    84970     0.228885688  9729  U   N [fio] 11
 65,224  8    84971     0.228888429  9729  Q  WS 5743016 + 8 [fio]
 65,224  8    84972     0.228888728  9729  G  WS 5743016 + 8 [fio]
 65,224 10        1     0.243064252  9729  Q  WS 5757368 + 8 [fio]
 65,224 10        2     0.243065348  9729  G  WS 5757368 + 8 [fio]
 65,224 10        3     0.243066110  9729  I  WS 5757368 + 8 [fio]
 65,224 10        4     0.243066816  9729  D  WS 5757368 + 8 [fio]
...
 65,224 11    42478     0.322827200  9729  C  WS 5831064 + 8 [0]
 65,224 11    42479     0.322833478  9729  Q  WS 5831144 + 8 [fio]
 65,224 11    42480     0.322833826  9729  G  WS 5831144 + 8 [fio]
 65,224  8    84973     0.334959322  9729  Q  WS 5842992 + 8 [fio]
 65,224  8    84974     0.334960161  9729  G  WS 5842992 + 8 [fio]
 65,224  8    84975     0.334960993  9729  I  WS 5842992 + 8 [fio]
 65,224  8    84976     0.334961632  9729  D  WS 5842992 + 8 [fio]
 65,224  8    84977     0.334966226  9729  U   N [fio] 1

# blkparse sdae |grep "WS 5743016"
 65,224  8    84971     0.228888429  9729  Q  WS 5743016 + 8 [fio]
 65,224  8    84972     0.228888728  9729  G  WS 5743016 + 8 [fio]

# blktrace --version
blktrace version 2.0.0

kernel 2.6.32-431.17.1.el6.x86_64