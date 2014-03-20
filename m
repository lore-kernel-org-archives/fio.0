Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34778 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbaCTSAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Mar 2014 14:00:04 -0400
Received: by mail-pa0-f46.google.com with SMTP id kp14so1283950pab.33
        for <fio@vger.kernel.org>; Thu, 20 Mar 2014 11:00:02 -0700 (PDT)
Received: from cayuga.dssd.com (50-76-39-249-ip-static.hfc.comcastbusiness.net. [50.76.39.249])
        by mx.google.com with ESMTPSA id yj1sm13318737pab.30.2014.03.20.10.59.57
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Mar 2014 11:00:01 -0700 (PDT)
From: castor.fu@egocast.org
Subject: Re: unlink
Date: Thu, 20 Mar 2014 10:59:28 -0700
Message-Id: <1395338370-89038-1-git-send-email-castor.fu@egocast.org>
In-Reply-To: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
References: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I think it makes sense to include 'unlink' in the ioengine API.

The Unix semantics of being able to unlink open files goes back a long ways,
but for those environments which don't match it, the following patch gives
an opportunity to handle things differently.

I also have a patch for some stylistic issues...

-castor

