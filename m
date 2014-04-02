Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi2.enovance.com ([94.143.117.217]:2667 "EHLO
	mxi2.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbaDBIdt (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Apr 2014 04:33:49 -0400
Received: from mxi1.enovance.com (mxi1.enovance.com [94.143.114.217])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mxi2.enovance.com (Postfix) with ESMTP id 3EBFB8028A5
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 10:33:48 +0200 (CEST)
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 35D11113133B
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 10:33:48 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 329073C81412
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 10:33:48 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 3G8P0mT6SXAV for <fio@vger.kernel.org>;
	Wed,  2 Apr 2014 10:33:44 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 1DA17126CC23
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 10:33:44 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aCUC3N5qTNYN for <fio@vger.kernel.org>;
	Wed,  2 Apr 2014 10:33:44 +0200 (CEST)
Received: from localhost.localdomain (94-143-112-83.enovance.net [94.143.112.83])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 097423C81412
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 10:33:44 +0200 (CEST)
Message-ID: <533BCB67.4050709@enovance.com>
Date: Wed, 02 Apr 2014 10:33:43 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Curious code in init()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey Jens,

The following code is pretty confusing for me :
http://git.kernel.dk/?p=fio.git;a=blob;f=init.c;h=c3996a76c12840e3ab3cf6514e5d5dce611a1077;hb=HEAD#l1962

The "if (nr_clients && fio_clients_connect()) {" is using the do_exit 
concept while being after the code that manage it and does a return -1 
while exit code is set to 1.

I don't get how it should be fixed.
1- we shall move the if nr_clients before the "if (do_exit", remove the 
return -1 and adjust the exit_code ?
2- we shall get rid of the do_exit & exit code semantic of the if 
nr_clients.

What was the intent while reading the code ? ;o)

Erwan,
