Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:31551 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753071AbdDJUUF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Apr 2017 16:20:05 -0400
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 9704461E72
        for <fio@vger.kernel.org>; Mon, 10 Apr 2017 20:20:04 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Adding IO engine
Date: Mon, 10 Apr 2017 20:19:24 +0000
Message-ID: <DF4PR84MB0169FBAF86B498BF07B4D7D2AB010@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
In-Reply-To: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Deyoung Hong (dhong)" <dhong@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>


> 1)  If I want to submit a new IO engine with fio and it has a dependency
> on an external library, how does that work when fio is compiled?  Please
> also point me to info how to submit a new IO engine to be packaged with
> fio?

The pmemblk and dev-dax ioengines are relatively new.  See
http://www.spinics.net/lists/fio/msg05370.html for some
patches related to their library handling.


---
Robert Elliott, HPE Persistent Memory


