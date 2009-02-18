Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:1794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZBRXMx (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Feb 2009 18:12:53 -0500
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id n1INCodc005046
	for <fio@vger.kernel.org>; Wed, 18 Feb 2009 23:12:50 GMT
Received: from rv-out-0708.google.com (rvbf25.prod.google.com [10.140.82.25])
	by wpaz21.hot.corp.google.com with ESMTP id n1INCmle028386
	for <fio@vger.kernel.org>; Wed, 18 Feb 2009 15:12:49 -0800
Received: by rv-out-0708.google.com with SMTP id f25so127543rvb.22
        for <fio@vger.kernel.org>; Wed, 18 Feb 2009 15:12:48 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Feb 2009 15:12:48 -0800
Message-ID: <66dfd3fe0902181512o5a88da43waaf09834bd6d37ac@mail.gmail.com>
Subject: Disabling verify when norandommap is given
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
Is there a reason why there is a hard rule to disable verify when
norandommap option is also set?
Thanks
-radha
