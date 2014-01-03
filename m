Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:35563 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751773AbaACDhQ (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 2 Jan 2014 22:37:16 -0500
Message-ID: <52C6306C.8000704@nellans.org>
Date: Thu, 02 Jan 2014 21:37:16 -0600
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: very unstable IOPS in the same test on the same machine
References: <266864ba.12fb3.1435264174a.Coremail.tech8891@163.com> <52C58868.4050800@nellans.org> <12ab081a.346f.14356185dd9.Coremail.tech8891@163.com>
In-Reply-To: <12ab081a.346f.14356185dd9.Coremail.tech8891@163.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: tech8891 <tech8891@163.com>
Cc: fio@vger.kernel.org

On 01/02/2014 09:14 PM, tech8891 wrote:
> Thanks for your answer， Nellans!   I think 31k IOPS should be because the RAID card cache.   Seems we have 394MB cache in this controller, which is enough hold the 2 * 128M data.

While I'm not a megaraid expert it looks like you're using 4 seagate 10k 
rpm drives with a 3ms random read time (looked up specs from seagat) 
drives in a raid 10 with a stripe size of 64KB.  Raid 10
performance affects aside, you essentially have a raid-0 of two drives. 
At absolute best, each of your drives might be able to do 333 IOPS at a 
small random I/O size. 100% raid-0 efficiency would give you 666 IOPS 
peak.  So getting 400 IOPS with random block sizes within a 1.2G range 
(where the disk heads don't have to move much thus speeding up seek 
time), seems very reasonable.  Nothing seems obviously wrong to me with 
the performance you're seeing.
