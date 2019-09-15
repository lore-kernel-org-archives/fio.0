Return-Path: <fio-owner@vger.kernel.org>
Received: from dna.y42.org ([138.201.40.98]:33614 "EHLO dna.y42.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfIOWjN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 15 Sep 2019 18:39:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by dna.y42.org (Postfix) with ESMTP id 7D01B9EA11
        for <fio@vger.kernel.org>; Mon, 16 Sep 2019 00:31:17 +0200 (CEST)
Received: from dna.y42.org ([127.0.0.1])
        by localhost (dna.y42.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id amfDeJCo0klw for <fio@vger.kernel.org>;
        Mon, 16 Sep 2019 00:31:15 +0200 (CEST)
Received: from [192.168.2.2] (p2E5426A0.dip0.t-ipconnect.de [46.84.38.160])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by dna.y42.org (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Mon, 16 Sep 2019 00:31:15 +0200 (CEST)
From: Robert Urban <urban@unix-beratung.de>
Subject: porting fio to other OSes
Message-ID: <f5e8d9f9-445c-ff9a-5e34-48fcbd81454d@unix-beratung.de>
Date: Mon, 16 Sep 2019 00:31:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I would like to port fio to Tru64 UNIX. Looking at the various os/os-*.h files
it seems some compatibility functions must be implemented for the target OS.
"blockdev_size()" is one example.

Besides the very general comments in the "Platforms" section of the "README"
file, are there more detailed guidelines for porting fio to an OS? For example,
a list of the compatibility functions that must be implemented?

-rob


