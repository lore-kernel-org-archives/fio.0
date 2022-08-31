Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC7AECAAD1
	for <fio@archiver.kernel.org>; Wed, 31 Aug 2022 20:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiHaUxY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 31 Aug 2022 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiHaUxX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Aug 2022 16:53:23 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C79ED004
        for <fio@vger.kernel.org>; Wed, 31 Aug 2022 13:53:21 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 801D832008FE
        for <fio@vger.kernel.org>; Wed, 31 Aug 2022 16:53:17 -0400 (EDT)
Received: from imap44 ([10.202.2.94])
  by compute2.internal (MEProxy); Wed, 31 Aug 2022 16:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=skunkwerks.at;
         h=cc:content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1661979196; x=1662065596; bh=odwtW2lYbaZtMEhJKgI+TozXGHi/nVmM9Rp
        Sj+RmG+U=; b=cdwS2HC+8kErKAzVj/47jCh+1G5diQyg75k3z3tQ+muu2WxGYh6
        wPkNeBCJdgy2n/rn/jDNbnEEvMnOpA/R5+Gx3N/I6Sl3u3CUe4HnmLrIJWaXmdsC
        zIVQLy4rilvvGXRAnQHumxBH87hsPe7HWqA82dNc42YJ6SrczMKfDkPtmgEZDV0O
        bSPXfu1BfZwl0/bFhkcAIG+AqSq4kxHVcHvCTHdlJv4ZmVFrRETEV6mTeYjgx9GS
        XCo9QPKYZRW+ecrezMEvD3RIZlOLfUp3Ni71p+Ob/voN9sKWGX3lK/j8AVR+vBKj
        dyDs3VsBxryqSYycVPF2WoPfue6o9rdvnDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1661979196; x=
        1662065596; bh=odwtW2lYbaZtMEhJKgI+TozXGHi/nVmM9RpSj+RmG+U=; b=3
        PkCgnOnXa3DKa2qoNdblHY87F+pkdWnqaNmXYx1LIAxiqHNxmQiDPFIzAJ033If7
        QIMk3w5rgCRTgKvCWxDun8hOEgILOo3eN+h0liR/tWlSvWdS1lWVMwoJxm88UPNq
        SBN2tEhCKUKbjyj5l+2jyoo0PVLrE76EcuFhDlu3iseHOggysxTusHnCZpCStY+I
        GibYWZDx5juUo8fjRZlpIFasILXfbZ5oGRNFlQU7olvDAkGfBTs0TtdshwkGff3h
        ciM/SQJ9IKIN5h7HgovwvntTdbwIg9frqWpDFdJwKZ34RhrcQQh8YD9RkptbDMQ3
        zZy92nPTvQLIOZVLilaVA==
X-ME-Sender: <xms:PMoPY6wvIKEzzxLBihJtYN71RtGw4LAmPx7QzTCkG6XxlSKL7QEinQ>
    <xme:PMoPY2TwDui8Oi7OMvP5EcaRdH-HW1k3xgaNH6bPgBQbX8m-kfrocSC_YNoSZpZLx
    7GDsuZgyjYQjuodVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekiedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgesthdtre
    dtreertdenucfhrhhomhepfdffrghvvgcuvehothhtlhgvhhhusggvrhdfuceouggthhes
    shhkuhhnkhifvghrkhhsrdgrtheqnecuggftrfgrthhtvghrnheptefhffelfeejiefhte
    dtgeetvdefueekvedutdeghefhkeeiheevkeeikeetveffnecuffhomhgrihhnpehgihht
    hhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegutghhsehskhhunhhkfigvrhhkshdrrght
X-ME-Proxy: <xmx:PMoPY8WK5oUq-YxaKvzZUSi5Lk3mRfhVsafHqCwAryEYqokp96_h2w>
    <xmx:PMoPYwiAVSyE4xdSBUtn1bJPMh2z92B3FbDbqZgrSU9ETS6j0uWeBg>
    <xmx:PMoPY8B3EuVEps1hLgH8Y8lZ38r2wss6vZJtMow30W7DKch2LIHNtA>
    <xmx:PMoPY_Nj7gZIFKVz043aUHfZXxZDGcdgKreWUVf6Xtkx5CTbMRSJAQ>
Feedback-ID: ic0e84090:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 431CA36A0073; Wed, 31 Aug 2022 16:53:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-841-g7899e99a45-fm-20220811.002-g7899e99a
Mime-Version: 1.0
Message-Id: <b38a5679-b46d-4b24-8cda-80cb7554049d@www.fastmail.com>
Date:   Wed, 31 Aug 2022 20:52:55 +0000
From:   "Dave Cottlehuber" <dch@skunkwerks.at>
To:     fio@vger.kernel.org
Subject: how to translatie real-world workload to fio jobs?
Content-Type: text/plain
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm new to fio, and its excellent documentation. While I can use it successfully to compare (fio) based loads across various hardware, I'm a bit lost on how to translate an observed production workload, across to fio.

My overall objective is to reproduce a production DB load with fio, and see how the busy/latency/queue depth improves for a variety of different improved storage arrangements.

What I have in prod is a single network block storage device

via atop:
- 100% busy 100% of the time
- mostly doing 200MiB/s read, 3MiB/s write
- avq 66.82

clearly this NBD is insufficient.

I've found https://github.com/iovisor/bcc which will be my next step to get more detailed information.

Does anybody have other tools, sysctls or metrics to look at, and suggestions on how they can be mapped to fio usage?

thanks
dch


