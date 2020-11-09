Return-Path: <fio-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43434 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgKIQqo (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Nov 2020 11:46:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] dynamic engines: fix several issues
Date: Mon,  9 Nov 2020 10:46:27 -0600
Message-Id: <1604940390-21215-1-git-send-email-sandeen@redhat.com>
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: sitsofe@yahoo.com, ykorman@gmail.com, rjones@redhat.com

1) Fix the build
2) Fix engine loading
3) Fix engine listing

Thanks,
-Eric


