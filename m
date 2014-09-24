Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx1.hgst.com ([199.255.44.36]:34748 "EHLO
	sjc00mx1.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaIXVIY convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 24 Sep 2014 17:08:24 -0400
From: Arash Jamalian <Arash.Jamalian@hgst.com>
Subject: FIO performance testing
Date: Wed, 24 Sep 2014 21:08:17 +0000
Message-ID: <D04880D0.333F%arash.jamalian@hgst.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <821568F7AA34AB4084E05A3F747DEC0B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Steven Roberts <steve@blueotter.net>

Hi,

I am tasked with testing several NAS HDDs connected to a Ubuntu Host. I am
being asked to run performance tests with fio. Besides the how to
document, can you share any documentation for maximizing video file
performance?


In particular, where can I get more information about IO engines? Which
engine to use for NAS systems when measuring video file performance?
What is the relationship between the parameters size and runtime? Does
runtime become redundant when we specify the size?

Best,
Arash Jamalian
Electrical and Firmware Development Engineer
D: 408-717-8040 | M: 408-601-9513
Email: Arash.Jamalian@hgst.com
HGST Inc., a Western Digital Company
3403 Yerba Buena Rd., San Jose, CA 95135

