Return-Path: <fio-owner@vger.kernel.org>
Received: from hop-nat-141.emc.com ([168.159.213.141]:40862 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161061Ab3FUNhh convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 21 Jun 2013 09:37:37 -0400
Received: from hop04-l1d11-si01.isus.emc.com (HOP04-L1D11-SI01.isus.emc.com [10.254.111.54])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id r5LDbURg009335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Fri, 21 Jun 2013 09:37:34 -0400
Received: from mailhub.lss.emc.com (mailhubhoprd05.lss.emc.com [10.254.222.129]) by hop04-l1d11-si01.isus.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Fri, 21 Jun 2013 09:37:17 -0400
Received: from mxhub32.corp.emc.com (mxhub32.corp.emc.com [128.222.70.172])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id r5LDbG9D021658
	for <fio@vger.kernel.org>; Fri, 21 Jun 2013 09:37:17 -0400
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Fri, 21 Jun 2013 09:37:14 -0400
Subject: The problem of blocks overwriting by multiple writers for raw
 devices
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C832466199B3@MX44A.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,

Question/suggestion (I am almost sure that it was already discussed here, but maybe ...):

Why not to divide a raw device size for multithreaded write by number of threads and let every thread to write on a separate chunk (as you do for FS - every thread writes to a separate file)? This will solves the problem of blocks overwriting by multiple writers.

Thank you
Konstantin
