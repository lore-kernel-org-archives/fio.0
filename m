Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:42446 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768Ab3CNF6P (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 14 Mar 2013 01:58:15 -0400
Received: From
	localhost.localdomain ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Thu, 14 Mar 2013 16:58:11 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Thu, 14 Mar 2013 16:57:37 +1100
Subject: [PATCH 0/4] Cross compile improvements
Message-Id: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This set improves handling of cross compilation to the point where
Android can now build with no special-casing in the configure script.

Tested on Linux/x86 and Darwin/x86_64 native, and cross compile from
Linux/x86 to Android/arm and Linux/arm.  I dont have access to any
big endian machine, so a sanity check of the endianess changes would
be appreciated.

Aaron Carroll (4):
  Propagate target OS from configure to Makefile
  configure: compile-time word size detection
  configure: endianness check for cross compile
  Android: remove static Android configuration

 Makefile  |   21 +++++++--------
 configure |   79 +++++++++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 64 insertions(+), 36 deletions(-)

