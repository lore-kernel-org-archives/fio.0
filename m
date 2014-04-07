Return-Path: <fio-owner@vger.kernel.org>
Received: from server506k.appriver.com ([50.56.144.157]:53057 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754665AbaDGUYc convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 7 Apr 2014 16:24:32 -0400
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: Mixing command line and job file parameters
Date: Mon, 7 Apr 2014 20:24:30 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB1086777F@DAGN05B-E6.exg6.exghost.com>
References: <A7A1D348E34E024BBC74480FB93A2EAB10866E58@DAGN05B-E6.exg6.exghost.com>
 <20140405032414.GB18464@kernel.dk> <533F8189.7080103@kernel.dk>
 <53417D88.2080308@kernel.dk>
In-Reply-To: <53417D88.2080308@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

(Jens- Thanks for the speedy work on this.)

I just pulled from git and built (fio-2.1.7-29-gbc4f5). 

The patch will supply the parameter if it was missing from the config:

works:
./fio --runtime=10 derf.cfg  (derf.cfg has "time_based" but no "runtime")

will throws "no runtime" error:
./fio derf.cfg

but will not replace an existing parameter as would happen if it's twice in the cfg file.  Also tried forcing global "./fio --name=global --runtime=10 derf.cfg", but no luck, either.

I'll try poking around the area of the changes. (I have 7-8 parameters that I want to individually override, and using env vars has gotten ugly and needs a helper script.)

z!

