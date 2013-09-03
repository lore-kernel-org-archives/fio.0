Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:46309 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760431Ab3ICTen (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Sep 2013 15:34:43 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id D7E6612002
	for <fio@vger.kernel.org>; Tue,  3 Sep 2013 21:34:39 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id D576A6E45DF
	for <fio@vger.kernel.org>; Tue,  3 Sep 2013 21:34:39 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eAmRU9yIDtaH for <fio@vger.kernel.org>;
	Tue,  3 Sep 2013 21:34:39 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 8A4B2492C837
	for <fio@vger.kernel.org>; Tue,  3 Sep 2013 21:34:39 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wqXlK4hSTYoi for <fio@vger.kernel.org>;
	Tue,  3 Sep 2013 21:34:39 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 360E65A8DC5B
	for <fio@vger.kernel.org>; Tue,  3 Sep 2013 21:34:39 +0200 (CEST)
Message-ID: <522639CE.2030705@enovance.com>
Date: Tue, 03 Sep 2013 21:34:38 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: How to loop a timebased job
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hey,

I'm on the IRC channel trying to help someone that needs to do the 
following :

doing IOs for x seconds
sleeping for y seconds
and looping this z times

While trying to setup this, I faced that loops and timebased seems 
exclusive options.
Am I wrong on this point ?

If not, would it be possible not to let them exclusive or add a new 
option to handle this case?

Cheers,
Erwan
