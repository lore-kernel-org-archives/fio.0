Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhBIOUk (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Feb 2021 09:20:40 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DACC061788
        for <fio@vger.kernel.org>; Tue,  9 Feb 2021 06:19:59 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id e18so22433036lja.12
        for <fio@vger.kernel.org>; Tue, 09 Feb 2021 06:19:59 -0800 (PST)
MIME-Version: 1.0
References: <CAN3sYqWQDKDHN-=g0GmAdQsgaMJu3eP7Hdti312te4RXnWTJnQ@mail.gmail.com>
 <CAN3sYqVUWNwS5Z9E50ckMct3eYP8wUCtfvHJLbW+Wj+Z5sSXVw@mail.gmail.com>
In-Reply-To: <CAN3sYqVUWNwS5Z9E50ckMct3eYP8wUCtfvHJLbW+Wj+Z5sSXVw@mail.gmail.com>
From: =?UTF-8?B?THVrw6HFoSBLdWLDrW4=?= <lukas.kubin@gmail.com>
Date: Tue, 9 Feb 2021 15:19:22 +0100
Message-ID: <CAN3sYqVn_sisNncYNyAzKrZfEBv8u-srh_2nFd_Ubw6R2RqQTw@mail.gmail.com>
Subject: Latency numbers missing in client-server output
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,
when running fio v3.16 in client/server mode on multiple servers in
parallel, I am not getting the common lat+clat+slat combination of
latency statistics in the output. Running the same job locally returns
these numbers.

I have also tried changing output-format to json+ to see all values
structured - that had all 0s in the respective latency sections.

Am I missing something or are the latency numbers not implemented in
client/server mode in my version/package? (ubuntu 20.04)

Greetings,

Lukas

