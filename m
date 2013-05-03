Return-Path: <fio-owner@vger.kernel.org>
Received: from mxin.ulb.ac.be ([164.15.128.112]:45219 "EHLO mxin.ulb.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab3ECJKH convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 3 May 2013 05:10:07 -0400
From: Michel Jansens <michel.jansens@ulb.ac.be>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: random read generates zero filled file 
Message-Id: <82C5A0D6-2960-41B7-89B6-1D8C72D011C0@ulb.ac.be>
Date: Fri, 3 May 2013 10:58:39 +0200
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying out FIO, and rand a random read job with a 12GB file.
It seems that the "Laying out IO file(s) " process generates a zero-filled file. This means that when compression is activated (on ZFS), no reads actually happens.

I tried adding a "buffer_compress_percentage=10" section to tell generated data should compress from only "10%" but this seems to apply only to actual benchmark job, not the 'laying out file's.

Am I missing something?

Thanks

Michel

