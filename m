Return-Path: <fio-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:34803 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0CSDQK convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 18 Mar 2010 23:16:10 -0400
Received: from [10.117.89.223] (dsl093-060-187.pit1.dsl.speakeasy.net [66.93.60.187])
	(user=dga2 mech=PLAIN (0 bits))
	by smtp.andrew.cmu.edu (8.14.3/8.14.3) with ESMTP id o2J3A560011014
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 18 Mar 2010 23:10:06 -0400
From: David Andersen <dga@cs.cmu.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Tiny fio performance bug with debug enabled
Date: Thu, 18 Mar 2010 23:10:05 -0400
Message-Id: <3D141235-660E-4F6D-8179-F106156B78A4@cs.cmu.edu>
Mime-Version: 1.0 (Apple Message framework v1077)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi, fio hackers:  

Version 285d451f5c3e034463ea49a5ba99e8e0eb1b83a2
(snapshot from yesterday)

Tiny performance tweak with -DFIO_INC_DEBUG enabled but no debug flags specified (the default if building from source):  the dprint macro calls getpid() before checking to see whether or not it's going to actually do anything.  This causes a bit of a slowdown if you've built with debugging but aren't using it.  The fix is to simply swap them:

debug.h:

#define dprint(type, str, args...)                              \
        do {                                                    \
                assert(type < FD_DEBUG_MAX);                    \
                if ((((1 << type)) & fio_debug) == 0)           \
                        break;                                  \
                pid_t pid = getpid();                           \

I wasn't sure what the style guidelines were for non-initial declaration & assignment, though...

Reproducing:  run fio under 'perf';  observe 1.x% of time taken by getpid(). :)

  -Dave

