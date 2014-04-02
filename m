Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi2.enovance.com ([94.143.117.217]:8063 "EHLO
	mxi2.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238AbaDBJHt (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Apr 2014 05:07:49 -0400
Received: from mxi1.enovance.com (mxi1.enovance.com [94.143.114.217])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mxi2.enovance.com (Postfix) with ESMTP id 61CBF802925
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:07:47 +0200 (CEST)
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 32771113133B
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:07:47 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 2FD483C81412
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:07:47 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id A_2XI7_aDpvT for <fio@vger.kernel.org>;
	Wed,  2 Apr 2014 11:07:43 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 1F2D07678CE
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:07:43 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qmQ03l3Uu97T for <fio@vger.kernel.org>;
	Wed,  2 Apr 2014 11:07:43 +0200 (CEST)
Received: from localhost.localdomain (94-143-112-83.enovance.net [94.143.112.83])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 0ABA0767832
	for <fio@vger.kernel.org>; Wed,  2 Apr 2014 11:07:43 +0200 (CEST)
Message-ID: <533BD35E.2020703@enovance.com>
Date: Wed, 02 Apr 2014 11:07:42 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Missing code in options.c ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

Sorry for spawning many emails but I think it's easier to follow having 
an email per problem instead of long emails with mixed stuff in it.

In options.c, we can see that :
http://git.kernel.dk/?p=fio.git;a=blob;f=options.c;h=4a54c98c15045864931ea503d3f7920bab4ae431;hb=HEAD#l212

ret = bssplit_ddir(&td->o, DDIR_READ, str) is performed while ret can be 
already setup in the previous line. I'm not mastering this part but I 
wonder what is lacks :

- a missing if (!ret) ?
- some strdup + free around ? Does using str directly is safe here ?

Wouldn't be easier to read to get some goto to the global free code at 
the end of the function instead of a multiple chained if (!ret) {} ?

Cheers,
Erwan,

