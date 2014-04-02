Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi2.enovance.com ([94.143.117.217]:11152 "EHLO
	mxi2.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbaDBJ1v (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Apr 2014 05:27:51 -0400
Received: from mxi1.enovance.com (mxi1.enovance.com [94.143.114.217])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mxi2.enovance.com (Postfix) with ESMTP id 3C93A8028F2
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:27:50 +0200 (CEST)
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 336CE113133B
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:27:50 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 30F496E46CB
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:27:50 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id FF6uaqhtP5TS for <fio@vger.kernel.org>;
	Wed,  2 Apr 2014 11:27:46 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 00E687034B5
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:27:46 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Ojg44VlWZBz3 for <fio@vger.kernel.org>;
	Wed,  2 Apr 2014 11:27:45 +0200 (CEST)
Received: from localhost.localdomain (94-143-112-83.enovance.net [94.143.112.83])
	by zimbra.enovance.com (Postfix) with ESMTPSA id E20616E4822
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:27:45 +0200 (CEST)
Message-ID: <533BD811.3050809@enovance.com>
Date: Wed, 02 Apr 2014 11:27:45 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Two fixes reported by clang
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

I've been running Clang 3.3 on fio and after reading many false positive 
errors, I found 1 real mistake and an improvement to make on the code.

Please find my branch here :
https://github.com/enovance/fio/tree/erwan/clang

Note that my previous emails about init & options.c were coming also 
from this clang pass.

Erwan,
