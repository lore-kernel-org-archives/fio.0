Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f200.google.com ([209.85.214.200]:35522 "EHLO
	mail-ob0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbADBxM (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 3 Jan 2015 20:53:12 -0500
Received: by mail-ob0-f200.google.com with SMTP id gq1so486327934obb.3
        for <fio@vger.kernel.org>; Sat, 03 Jan 2015 17:53:12 -0800 (PST)
MIME-Version: 1.0
From: Surendar Chandra <surendar@datrium.com>
Date: Sat, 3 Jan 2015 17:52:51 -0800
Message-ID: <CAO+GKh3gAXvugqduozYn-0VtG1=t4pdEnznCbM+H3Fd9Xknhqg@mail.gmail.com>
Subject: fio-2.1.14-17-g8671 in client/server mode: client continues to wait
 even after server is dead
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

In my case, the server machine rebooted and started a new fio server
after the client had issued a long running script. The original client
continues to futilely wait for the server to come back and return
results for its script. I am on Fedora 17.

Thanks much
