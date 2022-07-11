Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23184CCA47B
	for <fio@archiver.kernel.org>; Mon, 11 Jul 2022 13:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiGKN5M (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Jul 2022 09:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGKN5L (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Jul 2022 09:57:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC276069F
        for <fio@vger.kernel.org>; Mon, 11 Jul 2022 06:57:10 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g126so4852929pfb.3
        for <fio@vger.kernel.org>; Mon, 11 Jul 2022 06:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=m7W0KfQsWxOzxenbOYDKrI3zMRRW9ry1sTCwrVZiY+s=;
        b=wvXvoXnG4hcmJ3IIJOyPuPDVGeTwUkWptMaFpo0UaR2idvm2i218lr4fwUw19HK+ok
         g1f/SBM5lAlW5BbO3LeEl7lZ47leLQSGmKj1E64mJzOe9YP4PMVoLAsTt64CPUEHog0K
         drDY7lbFjYrBcqFqBnXgwLKE1DF7L92EuZJaTkykcpO+LVoYgtgYtTuDdIVHOyC9Et3b
         aGUm7cFmu+RdJwdSMRjvXS8hWYQjl1KkQmof7V0TrcluzYpw4F9j32RpNx2kRSxS3f0S
         ldlx43BD9EpUu6QJZ4CC2jyBD3AD/HL3v/GA6YmMMEv4ChUManVJXLQjdoEUYsTtB4bw
         cTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=m7W0KfQsWxOzxenbOYDKrI3zMRRW9ry1sTCwrVZiY+s=;
        b=z808k5pENkUChmRp4Uwj43XfpiSSbCOEz64Ens7aDHGUHGeW0vYPg+teo1fb73S1YP
         9hOWlW1SNV8G68v8oP/t2BqDhoqIye8quFSiO2GMlV1I46jvha7o2b98X04K/3mMLm7v
         zbacZXnOoNdgXRJLmTG2JF9tNf5N7ldzeHooxK3TUOOjGpcNkzOTYvHMaJfhgZ4lNLA5
         Ruv7hKCcp8f4DpWmtGVr8UmHz8nVccHg0F+2J+beu/7ZisRLgibP6bZl3verokY/p84e
         nF0wcSQwOPaNM7XukhEl9On4l3alvzKf2SLVqchG96lvAPdoaUy6bcEvek6jH/j2+nQ8
         RX1w==
X-Gm-Message-State: AJIora95x1v/wApEAyOfyT946owqJTixfQPWWtM0iGIa9IqEeEFL5SUl
        lql7gKBO7+93C7wX5LxdEAIA1VjvgAvu/Q==
X-Google-Smtp-Source: AGRyM1sz+RwE+EmCk4ME6kzf9GrL5fCWK7Aj7lD4sdd5ApHP9ni3fy2P/20a2TSRyhn/AhlhppnKKg==
X-Received: by 2002:a05:6a00:2449:b0:528:3a29:e79d with SMTP id d9-20020a056a00244900b005283a29e79dmr18827210pfj.39.1657547829916;
        Mon, 11 Jul 2022 06:57:09 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090322d000b001618b70dcc9sm4770816plg.101.2022.07.11.06.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:57:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, rebecca@bsdio.com
In-Reply-To: <20220711025547.11917-1-rebecca@bsdio.com>
References: <20220711025547.11917-1-rebecca@bsdio.com>
Subject: Re: [PATCH] Update README.rst to specify secure protocols where possible
Message-Id: <165754782923.7857.17888705330417111880.b4-ty@kernel.dk>
Date:   Mon, 11 Jul 2022 07:57:09 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sun, 10 Jul 2022 20:55:47 -0600, Rebecca Cran wrote:
> Change git clone commands to specify https instead of git or http.
> GitHub has removed support for the git protocol
> (https://github.blog/changelog/2022-03-15-removed-unencrypted-git-protocol-and-certain-ssh-keys/)
> and http accesses will normally redirect to https.
> 
> Update links to use https where possible: all the sites with updated links
> automatically redirect http accesses to https.
> 
> [...]

Applied, thanks!

[1/1] Update README.rst to specify secure protocols where possible
      commit: d6225c1550827077c0c0f9e1b8816b4f35cd5304

Best regards,
-- 
Jens Axboe


