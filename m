Return-Path: <fio-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:46793 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758541AbcIMWnz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2016 18:43:55 -0400
Date: Tue, 13 Sep 2016 18:43:54 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <1887684558.8387275.1473806634276.JavaMail.zimbra@redhat.com>
In-Reply-To: <1632172196.8370296.1473801360706.JavaMail.zimbra@redhat.com>
Subject: progress on fio --client
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Nick Dokos <ndokos@redhat.com>

Am now running with Jens patch "ignore SEND_ETA, if we can't fin a reply command ".   Thanks!  I was trying to solve it by increasing timeout.

I did the last commit on PR 241 to address the remaining comment.  If it looks ok to you, I would appreciate this being pulled in because it is important to distributed fio --client testing in order to get bandwidth/iops logs and latency histogram logs.    I have been testing it for about a week now with 900 workload generator threads across 7 hosts and it seems to work, especially now that assertion isn't firing because of above patch.

An unrelated minor problem - There are still a couple of threads that have trouble returning a fio histogram to the test driver, will look into that, but at least fio --client is getting almost all the logs now with PR 241, enough that meaningful stats can be generated.  Error messages are:

fio: failed decompressing log
fio: failed converting IO log

This doesn't happen for smaller numbers of workload generator threads.

-ben e
