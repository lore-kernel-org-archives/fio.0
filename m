Return-Path: <fio-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:59438 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab1KGLoi convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 7 Nov 2011 06:44:38 -0500
Received: from kryten (ppp121-44-79-234.lns20.syd6.internode.on.net [121.44.79.234])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by ozlabs.org (Postfix) with ESMTPSA id 5270E1007D3
	for <fio@vger.kernel.org>; Mon,  7 Nov 2011 22:44:37 +1100 (EST)
Date: Mon, 7 Nov 2011 22:44:36 +1100
From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] Fix big endian build
Message-ID: <20111107224436.3802ff85@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


I get the following error when building fio on PowerPC:

client.c: In function ‘convert_agg’:
client.c:641:22: error: invalid operands to binary & (have ‘long double’ and ‘long long unsigned int’)

It looks like we have things backwards, we should byteswap the
integer value before we convert it to a double.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/client.c b/client.c
index a61bc80..f167549 100644
--- a/client.c
+++ b/client.c
@@ -638,7 +638,7 @@ static void convert_agg(struct disk_util_agg *agg)
 	agg->io_ticks		= le32_to_cpu(agg->io_ticks);
 	agg->time_in_queue	= le32_to_cpu(agg->time_in_queue);
 	agg->slavecount		= le32_to_cpu(agg->slavecount);
-	agg->max_util.u.f	= __le64_to_cpu(fio_uint64_to_double(agg->max_util.u.i));
+	agg->max_util.u.f	= fio_uint64_to_double(__le64_to_cpu(agg->max_util.u.i));
 }
 
 static void convert_dus(struct disk_util_stat *dus)
