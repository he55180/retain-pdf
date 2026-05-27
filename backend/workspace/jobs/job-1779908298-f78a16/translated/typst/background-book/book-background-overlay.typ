#set text(font: "Source Han Sans SC", size: 11.4pt)
#import "@preview/cmarker:0.1.8"
#import "@preview/mitex:0.2.6": mitex
#show math.equation.where(block: false): set math.frac(style: "horizontal")
#let pdftr_fit_size(lo, hi, eps, fits) = {
  if hi - lo <= eps {
    lo
  } else {
    let mid = lo + (hi - lo) / 2
    if fits(mid) {
      pdftr_fit_size(mid, hi, eps, fits)
    } else {
      pdftr_fit_size(lo, mid, eps, fits)
    }
  }
}
#let pdftr_fit_single_line_markdown(markdown, max_size: 10pt, min_size: 9pt, fit_width: none, fit_height: none, weight: "regular", eps: 0.08pt) = {
  layout(size => {
    let allowed-width = if fit_width == none { size.width } else { calc.min(size.width, fit_width) }
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size) = box(inset: 0pt, clip: false)[#{
      set text(size: text_size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size) = {
      let measured = measure(render(text_size))
      measured.width <= allowed-width and measured.height <= allowed-height
    }
    let chosen-size = if fits(max_size) {
      max_size
    } else {
      pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt))
    }
    box(width: allowed-width, height: allowed-height, inset: 0pt, clip: false)[#{
      set text(size: chosen-size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
  })
}
#let pdftr_fit_markdown(markdown, max_size: 10pt, min_size: 9pt, max_leading: 0.66em, min_leading: 0.54em, fit_height: none, eps: 0.08pt) = {
  layout(size => {
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size, leading) = block(width: size.width)[#{
      set text(size: text_size)
      set par(leading: leading)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size, leading) = measure(width: size.width, render(text_size, leading)).height <= allowed-height
    if fits(max_size, max_leading) {
      render(max_size, max_leading)
    } else {
      let chosen-size = pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt, min_leading))
      render(chosen-size, min_leading)
    }
  })
}
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 1, width: 596.0pt))
#let rp0_item_p001_b002_0_md = "救护车服务协议"
#let rp0_item_p001_b002_0_body = block(width: 399.01pt, height: 17.59pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b002_0_md, max_size: 15.41pt, min_size: 12.0pt, fit_width: 399.01pt, fit_height: 17.59pt, weight: "bold") }]
#context {
  place(top + left, dx: 120.48046747843425pt, dy: 271.7320306396485pt, rp0_item_p001_b002_0_body)
}
#let rp0_item_p001_b003_1_md = "协议双方"
#let rp0_item_p001_b003_1_body = block(width: 101.76pt, height: 18.43pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b003_1_md, max_size: 16.15pt, min_size: 12.0pt, fit_width: 101.76pt, fit_height: 18.43pt, weight: "bold") }]
#context {
  place(top + left, dx: 262.87705586751304pt, dy: 350.2306164550781pt, rp0_item_p001_b003_1_body)
}
#let rp0_item_p001_b005_2_md = "与"
#let rp0_item_p001_b005_2_body = block(width: 49.4pt, height: 20.94pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b005_2_md, max_size: 18.35pt, min_size: 12.0pt, fit_width: 49.4pt, fit_height: 20.94pt, weight: "bold") }]
#context {
  place(top + left, dx: 288.65576171875pt, dy: 463.92488240559896pt, rp0_item_p001_b005_2_body)
}
#let rp0_item_p001_b007_3_md = "关于向中国港湾工程有限公司提供救护车服务的协议"
#let rp0_item_p001_b007_3_body = block(width: 363.9282872517904pt, height: 31.11669270833329pt)[#{ pdftr_fit_markdown(rp0_item_p001_b007_3_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 31.11669270833329pt) }]
#context {
  place(top + left, dx: 131.48614832560222pt, dy: 658.3811881510417pt, rp0_item_p001_b007_3_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 2, width: 596.0pt))
#let rp1_item_p002_b000_0_md = "本协议（2026年3月25日）"
#let rp1_item_p002_b000_0_body = block(width: 381.7pt, height: 10.47pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b000_0_md, max_size: 9.58pt, min_size: 7.38pt, fit_width: 381.7pt, fit_height: 10.47pt, weight: "bold") }]
#context {
  place(top + left, dx: 107.3477274576823pt, dy: 202.25479899088538pt, rp1_item_p002_b000_0_body)
}
#let rp1_item_p002_b001_1_md = "协议双方"
#let rp1_item_p002_b001_1_body = block(width: 55.74pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b001_1_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 55.74pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 283.7349487304688pt, dy: 230.67473144531252pt, rp1_item_p002_b001_1_body)
}
#let rp1_item_p002_b002_2_md = "EMERGENCY PLUS MEDICAL SERVICES TANZANIA LIMITED，一家根据《公司法》[第212章，2002年修订版]在坦桑尼亚注册成立的组织，其总部位于坦桑尼亚达累斯萨拉姆市乌尔西诺庄园查托街18号，邮政信箱10391，电话：+255 753 533495，电子邮箱：info@eplus.co.tz（以下简称“E-Plus”，该称谓在上下文允许的情况下应包括其继承人和许可受让人），为一方。"
#let rp1_item_p002_b002_2_body = block(width: 404.54348347981767pt, height: 80.58413533528648pt)[#{ pdftr_fit_markdown(rp1_item_p002_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 80.58413533528648pt) }]
#context {
  place(top + left, dx: 108.85043029785156pt, dy: 263.99926330566404pt, rp1_item_p002_b002_2_body)
}
#let rp1_item_p002_b003_3_md = "与"
#let rp1_item_p002_b003_3_body = block(width: 27.45pt, height: 13.4pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b003_3_md, max_size: 12.26pt, min_size: 10.06pt, fit_width: 27.45pt, fit_height: 13.4pt, weight: "bold") }]
#context {
  place(top + left, dx: 298.264555867513pt, dy: 357.10815836588546pt, rp1_item_p002_b003_3_body)
}
#let rp1_item_p002_b004_4_md = "CHINAHARBOURENGINEERINGCOMPANYLIMITED，一家在坦桑尼亚根据《公司法》注册成立的组织（注册编号：99870），纳税人识别号：121-046164，其总部位于Lugoda Street-Gerezani，P.O.Box 32550，Dar es Salaam，Tanzania，电话：+255612612688，电子邮箱：（以下简称“客户”，该称谓在上下文允许的情况下应包括其继承人和受让人），作为另一方。"
#let rp1_item_p002_b004_4_body = block(width: 400.522151184082pt, height: 72.60555257161451pt)[#{ pdftr_fit_markdown(rp1_item_p002_b004_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 72.60555257161451pt) }]
#context {
  place(top + left, dx: 110.01449305216471pt, dy: 388.09238566080734pt, rp1_item_p002_b004_4_body)
}
#let rp1_item_p002_b005_5_md = "序言"
#let rp1_item_p002_b005_5_body = block(width: 64.6pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b005_5_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 64.6pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 102.36342875162761pt, dy: 475.5507486979167pt, rp1_item_p002_b005_5_body)
}
#let rp1_item_p002_b006_6_md = "鉴于客户是一家在坦桑尼亚正式注册的实体，提供银行及其他相关服务。"
#let rp1_item_p002_b006_6_body = block(width: 402.934966023763pt, height: 23.536948242187464pt)[#{ pdftr_fit_markdown(rp1_item_p002_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.536948242187464pt) }]
#context {
  place(top + left, dx: 110.50127716064452pt, dy: 500.68867919921877pt, rp1_item_p002_b006_6_body)
}
#let rp1_item_p002_b007_7_md = "鉴于客户希望就由E-Plus提供的救护车服务作出安排。"
#let rp1_item_p002_b007_7_body = block(width: 403.73918609619136pt, height: 24.7337500000001pt)[#{ pdftr_fit_markdown(rp1_item_p002_b007_7_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.7337500000001pt) }]
#context {
  place(top + left, dx: 110.09915186564128pt, dy: 537.64923828125pt, rp1_item_p002_b007_7_body)
}
#let rp1_item_p002_b008_8_md = "而且，鉴于E-Plus已获得许可并同意根据本协议的条款和条件提供一辆配备有操作员和护理人员的装备齐全的救护车。"
#let rp1_item_p002_b008_8_body = block(width: 402.9349273681641pt, height: 37.100625000000036pt)[#{ pdftr_fit_markdown(rp1_item_p002_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 37.100625000000036pt) }]
#context {
  place(top + left, dx: 111.34787445068359pt, dy: 574.5419319661459pt, rp1_item_p002_b008_8_body)
}
#let rp1_item_p002_b009_9_md = "兹，因此，客户与E-Plus，鉴于本协议此后规定或载述之条款、相互承诺、契约及条件，特此约定如下："
#let rp1_item_p002_b009_9_body = block(width: 403.73919576009115pt, height: 23.138052571614594pt)[#{ pdftr_fit_markdown(rp1_item_p002_b009_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.74em, min_leading: 0.66em, fit_height: 23.138052571614594pt) }]
#context {
  place(top + left, dx: 110.52244110107421pt, dy: 623.3261356608073pt, rp1_item_p002_b009_9_body)
}
#let rp1_item_p002_b010_10_md = "1. 生效与期限"
#let rp1_item_p002_b010_10_body = block(width: 165.52pt, height: 10.89pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b010_10_md, max_size: 9.96pt, min_size: 7.76pt, fit_width: 165.52pt, fit_height: 10.89pt, weight: "bold") }]
#context {
  place(top + left, dx: 122.24773178100587pt, dy: 660.1699145507813pt, rp1_item_p002_b010_10_body)
}
#let rp1_item_p002_b011_11_md = "本协议自2026年4月1日起生效，至2026年9月30日止。若客户有意续签本协议，客户应通知RENG"
#let rp1_item_p002_b011_11_body = block(width: 370.36234741210933pt, height: 22.73908040364597pt)[#{ pdftr_fit_markdown(rp1_item_p002_b011_11_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 22.73908040364597pt) }]
#context {
  place(top + left, dx: 144.3543284098307pt, dy: 685.6995109049478pt, rp1_item_p002_b011_11_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 3, width: 596.0pt))
#let rp2_item_p003_b000_0_md = "在合同期满前至少一（1）个月。本协议应始终可依据本协议所载条款予以终止。"
#let rp2_item_p003_b000_0_body = block(width: 371.9708938598633pt, height: 24.334816080729126pt)[#{ pdftr_fit_markdown(rp2_item_p003_b000_0_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729126pt) }]
#context {
  place(top + left, dx: 141.01029586791992pt, dy: 116.21212890625pt, rp2_item_p003_b000_0_body)
}
#let rp2_item_p003_b001_1_md = "2. 标准："
#let rp2_item_p003_b001_1_body = block(width: 72.2pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b001_1_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 72.2pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 116.0993626912435pt, dy: 217.92107503255212pt, rp2_item_p003_b001_1_body)
}
#let rp2_item_p003_b002_2_md = "E-Plus承诺，其将按照经批准的国民健康与安全标准、陆路运输监管局（LATRA）以及E-Plus要求和建议的任何其他国际标准，向客户提供装备齐全的救护车，并提供救护服务。救护服务应一天24小时、一周7天（24/7）提供，不分周末和公共假日。鉴于服务的重要性，双方明确约定，救护服务将一天24小时、一周7天不间断提供。"
#let rp2_item_p003_b002_2_body = block(width: 371.97088419596355pt, height: 82.97773885091144pt)[#{ pdftr_fit_markdown(rp2_item_p003_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 82.97773885091144pt) }]
#context {
  place(top + left, dx: 140.16370747884116pt, dy: 245.82665181477867pt, rp2_item_p003_b002_2_body)
}
#let rp2_item_p003_b003_3_md = "3. 客户的义务："
#let rp2_item_p003_b003_3_body = block(width: 134.27pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b003_3_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 134.27pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 118.07827250162761pt, dy: 345.2614420572917pt, rp2_item_p003_b003_3_body)
}
#let rp2_item_p003_b004_4_md = "a. 当患者提出询问时，客户应联系 E-Plus 并请求救护车服务。来电者应表明其为客户代表身份，并提供紧急情况详情，包括但不限于：紧急情况性质、紧急情况发生地点、可提供进一步紧急情况详情的现场联系人、受影响伤员/患者人数。"
#let rp2_item_p003_b004_4_body = block(width: 356.2877858479818pt, height: 70.61088297526044pt)[#{ pdftr_fit_markdown(rp2_item_p003_b004_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 70.61088297526044pt) }]
#context {
  place(top + left, dx: 156.6828180948893pt, dy: 371.47733439127603pt, rp2_item_p003_b004_4_body)
}
#let rp2_item_p003_b005_5_md = "客户应通过电子邮件（dispatch@eplus.co.tz 和 info@eplus.co.tz）向 E-Plus 提供一份书面付款保证书，声明客户同意依照附件3规定的费率就救护车服务接受开票。"
#let rp2_item_p003_b005_5_body = block(width: 354.27713419596364pt, height: 35.504889322916654pt)[#{ pdftr_fit_markdown(rp2_item_p003_b005_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 35.504889322916654pt) }]
#context {
  place(top + left, dx: 158.32308247884114pt, dy: 458.63114095052083pt, rp2_item_p003_b005_5_body)
}
#let rp2_item_p003_b006_6_md = "c. 客户应支付一笔不可退还的预聘费，金额为 TZS 2,700,000，涵盖合同期限内的六（6）个月。该预聘费不包括救护车服务费，救护车服务费应根据本协议附件3所载费率计收。"
#let rp2_item_p003_b006_6_body = block(width: 357.09205423990886pt, height: 49.06856608072917pt)[#{ pdftr_fit_markdown(rp2_item_p003_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 49.06856608072917pt) }]
#context {
  place(top + left, dx: 156.70398305257163pt, dy: 507.0206486002604pt, rp2_item_p003_b006_6_body)
}
#let rp2_item_p003_b007_7_md = "4. 发票与付款"
#let rp2_item_p003_b007_7_body = block(width: 129.63pt, height: 14.66pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b007_7_md, max_size: 13.41pt, min_size: 11.21pt, fit_width: 129.63pt, fit_height: 14.66pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.53856709798177pt, dy: 569.7083024088541pt, rp2_item_p003_b007_7_body)
}
#let rp2_item_p003_b008_8_md = "a. E-Plus 应提供根据本协议附件3所载约定费率计算之发票，该费率可根据现行市场行情及双方协商一致进行调整（上浮或下调）。在服务期限内，客户应在收到完整、正确且无争议的原始发票及对账单后三十(30)日内，并在服务已按客户要求令人满意地交付的前提下，以事后支付方式结清款项。"
#let rp2_item_p003_b008_8_body = block(width: 353.0707509358724pt, height: 83.37669189453118pt)[#{ pdftr_fit_markdown(rp2_item_p003_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 83.37669189453118pt) }]
#context {
  place(top + left, dx: 156.17486012776692pt, dy: 599.3605432128907pt, rp2_item_p003_b008_8_body)
}
#let rp2_item_p003_b009_9_md = "b. 救护车服务免征税收。若据此发生法律变更，则本协议附件3中规定的费率应"
#let rp2_item_p003_b009_9_body = block(width: 349.4515818277995pt, height: 24.334816080729297pt)[#{ pdftr_fit_markdown(rp2_item_p003_b009_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729297pt) }]
#context {
  place(top + left, dx: 156.0796188354492pt, dy: 696.3603019205729pt, rp2_item_p003_b009_9_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 4, width: 596.0pt))
#let rp3_item_p004_b000_0_md = "经双方同意修订，以包含服务期限内的所有适用税费、关税和征收款。"
#let rp3_item_p004_b000_0_body = block(width: 324.11731109619143pt, height: 22.739089965820312pt)[#{ pdftr_fit_markdown(rp3_item_p004_b000_0_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 22.739089965820312pt) }]
#context {
  place(top + left, dx: 173.19133936564126pt, dy: 116.58559926350915pt, rp3_item_p004_b000_0_body)
}
#let rp3_item_p004_b001_1_md = "c. 所有发票应包含服务提供商的纳税人登记号/税务识别号及完整地址。"
#let rp3_item_p004_b001_1_body = block(width: 338.99617970784504pt, height: 23.138033447265627pt)[#{ pdftr_fit_markdown(rp3_item_p004_b001_1_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.74em, min_leading: 0.66em, fit_height: 23.138033447265627pt) }]
#context {
  place(top + left, dx: 157.07436396280926pt, dy: 152.2475217692057pt, rp3_item_p004_b001_1_body)
}
#let rp3_item_p004_b003_2_md = "账户名称："
#let rp3_item_p004_b003_2_body = block(width: 73.18777618408205pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b003_2_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 166.5879305521647pt, dy: 212.18061279296876pt, rp3_item_p004_b003_2_body)
}
#let rp3_item_p004_b005_3_md = "银行名称："
#let rp3_item_p004_b005_3_body = block(width: 59.51532948811848pt, height: 12.366874999999993pt)[#{ pdftr_fit_markdown(rp3_item_p004_b005_3_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 12.366874999999993pt) }]
#context {
  place(top + left, dx: 166.22812932332357pt, dy: 241.44132864583338pt, rp3_item_p004_b005_3_body)
}
#let rp3_item_p004_b006_4_md = "Diamond Trustbank (DTB) T Ltd"
#let rp3_item_p004_b006_4_body = block(width: 158.43948160807287pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b006_4_md, max_size: 11.11pt, min_size: 10.31pt, max_leading: 0.29em, min_leading: 0.22em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 278.4649108886719pt, dy: 225.72306477864586pt, rp3_item_p004_b006_4_body)
}
#let rp3_item_p004_b007_5_md = "分行："
#let rp3_item_p004_b007_5_body = block(width: 38.60455423990888pt, height: 9.574337565104145pt)[#{ pdftr_fit_markdown(rp3_item_p004_b007_5_md, max_size: 9.2pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.574337565104145pt) }]
#context {
  place(top + left, dx: 166.52443389892576pt, dy: 255.35725068359386pt, rp3_item_p004_b007_5_body)
}
#let rp3_item_p004_b008_6_md = "Mbezi 分行"
#let rp3_item_p004_b008_6_body = block(width: 67.15581156412753pt, height: 10.372205403645864pt)[#{ pdftr_fit_markdown(rp3_item_p004_b008_6_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.372205403645864pt) }]
#context {
  place(top + left, dx: 274.79283192952477pt, dy: 252.32422340494787pt, rp3_item_p004_b008_6_body)
}
#let rp3_item_p004_b009_7_md = "TZS 账户号码：0264997001(TZS)"
#let rp3_item_p004_b009_7_body = block(width: 190.20782216389972pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b009_7_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 169.66740544637042pt, dy: 280.37540556640624pt, rp3_item_p004_b009_7_body)
}
#let rp3_item_p004_b010_8_md = "USD 账号:0264997002 (USD)"
#let rp3_item_p004_b010_8_body = block(width: 191.81632029215496pt, height: 11.967960205078157pt)[#{ pdftr_fit_markdown(rp3_item_p004_b010_8_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967960205078157pt) }]
#context {
  place(top + left, dx: 169.7097343444824pt, dy: 307.9422583902994pt, rp3_item_p004_b010_8_body)
}
#let rp3_item_p004_b013_9_md = "5. E-Plus 的义务："
#let rp3_item_p004_b013_9_body = block(width: 119.92pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp3_item_p004_b013_9_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 119.92pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.71847127278646pt, dy: 329.52718476562495pt, rp3_item_p004_b013_9_body)
}
#let rp3_item_p004_b014_10_md = "a. E-Plus 承诺将按照经批准的国家健康与安全标准、陆路运输监管局（LATRA）以及 E-Plus 要求和建议的其他任何国际标准，提供配备齐全的救护车，向客户提供救护车服务。救护车服务应每周 7 天、每天 24 小时（24/7）提供，无论周末还是公共假日。鉴于该服务的重要性，双方明确同意救护车服务将确保全天候不间断提供。"
#let rp3_item_p004_b014_10_body = block(width: 357.4941884358724pt, height: 93.74887817382807pt)[#{ pdftr_fit_markdown(rp3_item_p004_b014_10_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 93.74887817382807pt) }]
#context {
  place(top + left, dx: 156.71456553141275pt, dy: 386.94342131347656pt, rp3_item_p004_b014_10_body)
}
#let rp3_item_p004_b015_11_md = "E-Plus 应设立一个24小时可用的联系点，客户可通过该联系点在紧急情况下请求救护车服务。该服务通过致电 E-Plus 紧急调度中心（dispatch@eplus.co.tz）激活。"
#let rp3_item_p004_b015_11_body = block(width: 355.0814025878906pt, height: 60.23863932291664pt)[#{ pdftr_fit_markdown(rp3_item_p004_b015_11_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 60.23863932291664pt) }]
#context {
  place(top + left, dx: 158.34424743652343pt, dy: 497.91428984374994pt, rp3_item_p004_b015_11_body)
}
#let rp3_item_p004_b016_12_md = "E-Plus 应将其救护车在达累斯萨拉姆进行调度和部署，以最大限度地缩短到达紧急现场并开始提供护理所需的时间。"
#let rp3_item_p004_b016_12_body = block(width: 355.4835367838542pt, height: 36.70169108072923pt)[#{ pdftr_fit_markdown(rp3_item_p004_b016_12_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 36.70169108072923pt) }]
#context {
  place(top + left, dx: 157.93153076171873pt, dy: 572.7054283528646pt, rp3_item_p004_b016_12_body)
}
#let rp3_item_p004_b017_13_md = "d.E-Plus 应按照 E-Plus 标准程序的要求，填写所有必要的文件。这些文件包括用药记录、转运记录、患者初步评估等。此清单并非详尽无遗，仅为所需表格的指示性列举。"
#let rp3_item_p004_b017_13_body = block(width: 356.6899200439452pt, height: 59.83970540364567pt)[#{ pdftr_fit_markdown(rp3_item_p004_b017_13_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 59.83970540364567pt) }]
#context {
  place(top + left, dx: 156.27010142008461pt, dy: 623.5225295898438pt, rp3_item_p004_b017_13_body)
}
#let rp3_item_p004_b018_14_md = "e.E-Plus 应在约定服务范围内，确保在提供服务时使用其自有设施，包括车辆、工具、机械、器具及设备，且不产生额外费用，并作为约定合同价格的组成部分。"
#let rp3_item_p004_b018_14_body = block(width: 356.6899200439452pt, height: 38.2973885091144pt)[#{ pdftr_fit_markdown(rp3_item_p004_b018_14_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 38.2973885091144pt) }]
#context {
  place(top + left, dx: 156.27010142008461pt, dy: 698.8017243326824pt, rp3_item_p004_b018_14_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 5, width: 596.0pt))
#let rp4_item_p005_b000_0_md = "f. 确保其车辆/救护车按照所有适用法律（包括所有国家运输与安全管理局条例及陆路运输监管局（LATRA）的规定）持有所有必要的执照、许可、批准、权限和许可证，并且此类车辆保持良好维修状态。"
#let rp4_item_p005_b000_0_body = block(width: 355.8856516520183pt, height: 61.03650716145826pt)[#{ pdftr_fit_markdown(rp4_item_p005_b000_0_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 61.03650716145826pt) }]
#context {
  place(top + left, dx: 156.24893646240233pt, dy: 116.53466389973961pt, rp4_item_p005_b000_0_body)
}
#let rp4_item_p005_b001_1_md = "应客户要求，向客户提供所有必要文件，包括车辆/救护车登记编号、有效的综合保险单及其人员（包括其救护车操作员）的详细信息。"
#let rp4_item_p005_b001_1_body = block(width: 356.68992004394534pt, height: 37.499558919270896pt)[#{ pdftr_fit_markdown(rp4_item_p005_b001_1_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 37.499558919270896pt) }]
#context {
  place(top + left, dx: 155.8468022664388pt, dy: 192.17461832682287pt, rp4_item_p005_b001_1_body)
}
#let rp4_item_p005_b002_2_md = "h. 确保其救护车驾驶员持有有效驾驶执照，并始终遵守所有交通规则及高速公路法规；同时确保其驾驶员始终持有有效的良好行为证明及警方无犯罪记录证明，并具备驾驶救护车所需的驾驶经验；"
#let rp4_item_p005_b002_2_body = block(width: 355.88565165201817pt, height: 49.06856608072914pt)[#{ pdftr_fit_markdown(rp4_item_p005_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 49.06856608072914pt) }]
#context {
  place(top + left, dx: 155.8256373087565pt, dy: 243.47127115885414pt, rp4_item_p005_b002_2_body)
}
#let rp4_item_p005_b003_3_md = "在所有与服务提供相关的事项上随时保持客户知情。在不限制本条款一般性原则的前提下，E-Plus 应指派其技术人员（须在正常工作日随时可联络，并有权代表 E-Plus 行事）按需协调、合作并向客户提供信息；"
#let rp4_item_p005_b003_3_body = block(width: 355.08139292399085pt, height: 71.00979777018216pt)[#{ pdftr_fit_markdown(rp4_item_p005_b003_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 71.00979777018216pt) }]
#context {
  place(top + left, dx: 157.07435989379883pt, dy: 307.4063865152996pt, rp4_item_p005_b003_3_body)
}
#let rp4_item_p005_b004_4_md = "确保其人员在值班时无酒精中毒及其他非法物质影响；"
#let rp4_item_p005_b004_4_body = block(width: 355.88564198811855pt, height: 26.728381347656295pt)[#{ pdftr_fit_markdown(rp4_item_p005_b004_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 26.728381347656295pt) }]
#context {
  place(top + left, dx: 155.40234807332357pt, dy: 392.5697896321614pt, rp4_item_p005_b004_4_body)
}
#let rp4_item_p005_b005_5_md = "k. 确保其根据本协议指派给客户的人员在值班时配备适当制服及所有其他必要的个人防护装备和服装（PPE），费用由其自行承担，并符合适用法律；且确保此类制服定期清洁并保持干净整洁；"
#let rp4_item_p005_b005_5_body = block(width: 355.88565165201817pt, height: 60.23863932291664pt)[#{ pdftr_fit_markdown(rp4_item_p005_b005_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 60.23863932291664pt) }]
#context {
  place(top + left, dx: 155.8256373087565pt, dy: 432.6836181640625pt, rp4_item_p005_b005_5_body)
}
#let rp4_item_p005_b006_6_md = "E-Plus 应始终将所需设备和用品保持在良好的工作状态。任何时间点所需的设备和用品清单见附录2。"
#let rp4_item_p005_b006_6_body = block(width: 355.0813832600911pt, height: 37.898492838541586pt)[#{ pdftr_fit_markdown(rp4_item_p005_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 37.898492838541586pt) }]
#context {
  place(top + left, dx: 156.65107065836588pt, dy: 505.815361328125pt, rp4_item_p005_b006_6_body)
}
#let rp4_item_p005_b007_7_md = "m. E-Plus 并非客户的代理人，且在任何情况下均不得如此声称。E-Plus 系独立顾问，客户或其员工在任何情况下均无需对 E-Plus、其代理人及雇员，以及任何根据 E-Plus 指示行事之人的作为或不作为所引发的任何不当行为、疏忽或其他可能产生的任何责任问题承担责任。"
#let rp4_item_p005_b007_7_body = block(width: 357.49417877197266pt, height: 71.80764648437503pt)[#{ pdftr_fit_markdown(rp4_item_p005_b007_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 71.80764648437503pt) }]
#context {
  place(top + left, dx: 154.59807968139648pt, dy: 558.6738134765625pt, rp4_item_p005_b007_7_body)
}
#let rp4_item_p005_b008_8_md = "E-Plus的服务提供应符合最高的临床和专业标准。E-Plus应遵守所有关于服务提供的适用法律、法规和标准。E-Plus雇用的所有人员应能胜任其职责，并在各自的岗位上持有并维持适用的有效证书/执照/认证。"
#let rp4_item_p005_b008_8_body = block(width: 357.09204457600913pt, height: 62.233308919270826pt)[#{ pdftr_fit_markdown(rp4_item_p005_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 62.233308919270826pt) }]
#context {
  place(top + left, dx: 154.58749720255534pt, dy: 646.6424194335938pt, rp4_item_p005_b008_8_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 6, width: 596.0pt))
#let rp5_item_p006_b000_0_md = "或职业。E-Plus 应对其员工的工作表现、资质许可及行为承担责任。"
#let rp5_item_p006_b000_0_body = block(width: 340.20256296793616pt, height: 25.531617838541635pt)[#{ pdftr_fit_markdown(rp5_item_p006_b000_0_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 25.531617838541635pt) }]
#context {
  place(top + left, dx: 172.76803716023764pt, dy: 115.40152913411463pt, rp5_item_p006_b000_0_body)
}
#let rp5_item_p006_b001_1_md = "5. 完整协议："
#let rp5_item_p006_b001_1_body = block(width: 108.51pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp5_item_p006_b001_1_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 108.51pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.85603612263998pt, dy: 178.45232503255212pt, rp5_item_p006_b001_1_body)
}
#let rp5_item_p006_b002_2_md = "本协议构成双方就本协议所涉事宜达成的完整协议与共识。"
#let rp5_item_p006_b002_2_body = block(width: 370.76449127197264pt, height: 22.73909952799488pt)[#{ pdftr_fit_markdown(rp5_item_p006_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 22.73909952799488pt) }]
#context {
  place(top + left, dx: 141.82514673868815pt, dy: 203.58659647623693pt, rp5_item_p006_b002_2_body)
}
#let rp5_item_p006_b003_3_md = "6. 不弃权："
#let rp5_item_p006_b003_3_body = block(width: 74.74pt, height: 11.73pt)[#{ pdftr_fit_single_line_markdown(rp5_item_p006_b003_3_md, max_size: 10.73pt, min_size: 8.53pt, fit_width: 74.74pt, fit_height: 11.73pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.43274408976237pt, dy: 240.4285514322916pt, rp5_item_p006_b003_3_body)
}
#let rp5_item_p006_b004_4_md = "本协议的任何变更均须由一方向另一方书面作出，方为有效。"
#let rp5_item_p006_b004_4_body = block(width: 371.1666254679362pt, height: 24.334835205078093pt)[#{ pdftr_fit_markdown(rp5_item_p006_b004_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334835205078093pt) }]
#context {
  place(top + left, dx: 141.41243006388348pt, dy: 266.02361226399734pt, rp5_item_p006_b004_4_body)
}
#let rp5_item_p006_b005_5_md = "7. 终止："
#let rp5_item_p006_b005_5_body = block(width: 76.42pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp5_item_p006_b005_5_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 76.42pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 118.32166188557943pt, dy: 304.94387674967453pt, rp5_item_p006_b005_5_body)
}
#let rp5_item_p006_b006_6_md = "任何一方可因另一方未能实质性履行本协议而终止本协议，由终止方发出通知。此外，客户有权在任何时候出于便利、无需正当事由，提前三十（30）日向E-Plus发出书面通知，暂停或终止本协议。"
#let rp5_item_p006_b006_6_body = block(width: 372.37299906412755pt, height: 57.04720621744781pt)[#{ pdftr_fit_markdown(rp5_item_p006_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 57.04720621744781pt) }]
#context {
  place(top + left, dx: 142.29076487223307pt, dy: 331.5757010904949pt, rp5_item_p006_b006_6_body)
}
#let rp5_item_p006_b007_7_md = "8. 通知："
#let rp5_item_p006_b007_7_body = block(width: 54.05pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp5_item_p006_b007_7_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 54.05pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.33749643961589pt, dy: 404.2305639648437pt, rp5_item_p006_b007_7_body)
}
#let rp5_item_p006_b008_8_md = "任何一方根据本协议向另一方发出的通知，应以书面形式或通过电报、传真或电子邮件发送，并以书面形式确认至以下地址。"
#let rp5_item_p006_b008_8_body = block(width: 371.970864868164pt, height: 35.10595540364591pt)[#{ pdftr_fit_markdown(rp5_item_p006_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 35.10595540364591pt) }]
#context {
  place(top + left, dx: 143.12678070068358pt, dy: 431.03271565755205pt, rp5_item_p006_b008_8_body)
}
#let rp5_item_p006_b014_9_md = "董事总经理"
#let rp5_item_p006_b014_9_body = block(width: 84.84958089192708pt, height: 11.967979329426953pt)[#{ pdftr_fit_markdown(rp5_item_p006_b014_9_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967979329426953pt) }]
#context {
  place(top + left, dx: 90.27833455403646pt, dy: 530.4514961751303pt, rp5_item_p006_b014_9_body)
}
#let rp5_item_p006_b015_10_md = "施工经理"
#let rp5_item_p006_b015_10_body = block(width: 98.11989339192706pt, height: 12.76580891927074pt)[#{ pdftr_fit_markdown(rp5_item_p006_b015_10_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 12.76580891927074pt) }]
#context {
  place(top + left, dx: 299.7355041503906pt, dy: 528.3550105794271pt, rp5_item_p006_b015_10_body)
}
#let rp5_item_p006_b024_11_md = "邮箱：info@eplus.co.tz"
#let rp5_item_p006_b024_11_body = block(width: 104.9561070760091pt, height: 10.771139322916724pt)[#{ pdftr_fit_markdown(rp5_item_p006_b024_11_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.771139322916724pt) }]
#context {
  place(top + left, dx: 92.07734095255533pt, dy: 608.9264420572916pt, rp5_item_p006_b024_11_body)
}
#let rp5_item_p006_b026_12_md = "9. 质量控制："
#let rp5_item_p006_b026_12_body = block(width: 95.85pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp5_item_p006_b026_12_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 95.85pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 107.37947642008464pt, dy: 658.4214469401041pt, rp5_item_p006_b026_12_body)
}
#let rp5_item_p006_b027_13_md = "救护车服务质量将通过客户指定主管机构定期进行的抽查和审计加以监控。E-Plus 负责每季度获取、监测客户反馈并据此采取行动，且将相关报告提交给客户主管机构。E-Plus 应负责确保持续更新的员工资质/执业许可、设备库存管理、用品、车辆牌照等事项。但是，在本协议生效时及协议有效期内相关资质/执业许可更新或指派员工发生变更时，客户应收到 E-Plus 及其员工资质/执业许可的副本。"
#let rp5_item_p006_b027_13_body = block(width: 371.9708745320637pt, height: 35.50488932291671pt)[#{ pdftr_fit_markdown(rp5_item_p006_b027_13_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 35.50488932291671pt) }]
#context {
  place(top + left, dx: 143.97336908976237pt, dy: 685.6825325520833pt, rp5_item_p006_b027_13_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 7, width: 596.0pt))
#let rp6_item_p007_b000_0_md = "10. 授权代表"
#let rp6_item_p007_b000_0_body = block(width: 153.69pt, height: 12.15pt)[#{ pdftr_fit_single_line_markdown(rp6_item_p007_b000_0_md, max_size: 11.11pt, min_size: 8.91pt, fit_width: 153.69pt, fit_height: 12.15pt, weight: "bold") }]
#context {
  place(top + left, dx: 102.47982711791992pt, dy: 192.8890167236328pt, rp6_item_p007_b000_0_body)
}
#let rp6_item_p007_b006_1_md = "董事总经理"
#let rp6_item_p007_b006_1_body = block(width: 84.04530766805013pt, height: 13.164742838541713pt)[#{ pdftr_fit_markdown(rp6_item_p007_b006_1_md, max_size: 12.65pt, min_size: 10.45pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.164742838541713pt) }]
#context {
  place(top + left, dx: 76.28842455546061pt, dy: 262.2719580078125pt, rp6_item_p007_b006_1_body)
}
#let rp6_item_p007_b007_2_md = "施工经理"
#let rp6_item_p007_b007_2_body = block(width: 97.31562499999995pt, height: 11.569007161458273pt)[#{ pdftr_fit_markdown(rp6_item_p007_b007_2_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.569007161458273pt) }]
#context {
  place(top + left, dx: 285.74558919270834pt, dy: 261.37225504557296pt, rp6_item_p007_b007_2_body)
}
#let rp6_item_p007_b010_3_md = "办公电话;+255753533495"
#let rp6_item_p007_b010_3_body = block(width: 129.08395589192708pt, height: 10.372205403645864pt)[#{ pdftr_fit_markdown(rp6_item_p007_b010_3_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.372205403645864pt) }]
#context {
  place(top + left, dx: 77.89694620768229pt, dy: 301.22720703125pt, rp6_item_p007_b010_3_body)
}
#let rp6_item_p007_b014_4_md = "11. 质量改进与患者安全方面及监测"
#let rp6_item_p007_b014_4_body = block(width: 333.57pt, height: 12.15pt)[#{ pdftr_fit_single_line_markdown(rp6_item_p007_b014_4_md, max_size: 11.11pt, min_size: 8.91pt, fit_width: 333.57pt, fit_height: 12.15pt, weight: "bold") }]
#context {
  place(top + left, dx: 111.22088419596354pt, dy: 338.88096008300784pt, rp6_item_p007_b014_4_body)
}
#let rp6_item_p007_b015_5_md = "E-Plus 必须确保遵守当地标准、国际标准以及组织内部规定，以提供最佳服务和实践。患者、访客和员工的安全与保障应始终得到确保。危及质量、安全和保障可能对合同条款产生严重影响。员工资质、知识、持续培训、岗位描述、职业着装、身份标识卡以及感染防控措施（如标准预防措施、废物管理等）是质量保证的关键方面。每季度应进行绩效监测和报告，内容应包括客户满意度、反馈、充分性监测以及不符合项关闭的响应。若出现任何不符合项，E-Plus 应负责提交行动计划。合同续签应基于这些绩效指标以及客户相关主管部门的绩效评估。"
#let rp6_item_p007_b015_5_body = block(width: 373.17729644775386pt, height: 142.0195955403646pt)[#{ pdftr_fit_markdown(rp6_item_p007_b015_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 142.0195955403646pt) }]
#context {
  place(top + left, dx: 141.04204330444335pt, dy: 367.8148075358073pt, rp6_item_p007_b015_5_body)
}
#let rp6_item_p007_b016_6_md = "12. 管辖法律"
#let rp6_item_p007_b016_6_body = block(width: 109.78pt, height: 11.73pt)[#{ pdftr_fit_single_line_markdown(rp6_item_p007_b016_6_md, max_size: 10.73pt, min_size: 8.53pt, fit_width: 109.78pt, fit_height: 11.73pt, weight: "bold") }]
#context {
  place(top + left, dx: 102.22585678100586pt, dy: 527.3196850585938pt, rp6_item_p007_b016_6_body)
}
#let rp6_item_p007_b017_7_md = "本协议应受坦桑尼亚联合共和国法律管辖并据其解释。"
#let rp6_item_p007_b017_7_body = block(width: 371.5687693277995pt, height: 24.334816080729183pt)[#{ pdftr_fit_markdown(rp6_item_p007_b017_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729183pt) }]
#context {
  place(top + left, dx: 142.6929000854492pt, dy: 552.4903474934896pt, rp6_item_p007_b017_7_body)
}
#let rp6_item_p007_b018_8_md = "13. 非合资企业或合伙企业"
#let rp6_item_p007_b018_8_body = block(width: 187.9pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp6_item_p007_b018_8_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 187.9pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 104.18359807332357pt, dy: 590.0938102213541pt, rp6_item_p007_b018_8_body)
}
#let rp6_item_p007_b019_9_md = "双方理解并同意，本协议中的任何内容均不得被视为或解释为在客户与E-Plus或任何其他方之间建立合伙关系或合资企业，亦不得使任何一方以任何方式对另一方的债务和义务承担责任。"
#let rp6_item_p007_b019_9_body = block(width: 372.37302805582686pt, height: 48.27073649088538pt)[#{ pdftr_fit_markdown(rp6_item_p007_b019_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 48.27073649088538pt) }]
#context {
  place(top + left, dx: 141.86747665405272pt, dy: 618.1867142740886pt, rp6_item_p007_b019_9_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 8, width: 596.0pt))
#let rp7_item_p008_b000_0_md = "14. 不可抗力"
#let rp7_item_p008_b000_0_body = block(width: 106.83pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp7_item_p008_b000_0_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 106.83pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 99.61200536092123pt, dy: 112.64926066080726pt, rp7_item_p008_b000_0_body)
}
#let rp7_item_p008_b001_1_md = "任何一方均不被视为违反本协议，前提是其履行义务（支付款项除外）的任何延迟或未能履行是由于超出其合理控制范围且非因其过错或疏忽所致。为此，此类行为或事件应包括但不限于：暴风雨、洪水、异常恶劣天气、不可抗力、流行病、大流行病、抗议示威、战争、恐怖主义或恐怖行为、暴乱、罢工、停工或其他工业干扰或不可预见的现场条件。若此类行为或事件确实发生，双方应努力克服由此产生的所有困难，并尽可能合理尽快恢复本协议所规定服务的正常开展和进度。"
#let rp7_item_p008_b001_1_body = block(width: 373.17727711995434pt, height: 108.90829060872397pt)[#{ pdftr_fit_markdown(rp7_item_p008_b001_1_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 108.90829060872397pt) }]
#context {
  place(top + left, dx: 139.3488665262858pt, dy: 141.8286204020182pt, rp7_item_p008_b001_1_body)
}
#let rp7_item_p008_b002_2_md = "15.争议解决"
#let rp7_item_p008_b002_2_body = block(width: 111.47pt, height: 13.4pt)[#{ pdftr_fit_single_line_markdown(rp7_item_p008_b002_2_md, max_size: 12.26pt, min_size: 10.06pt, fit_width: 111.47pt, fit_height: 13.4pt, weight: "bold") }]
#context {
  place(top + left, dx: 96.34204915364583pt, dy: 265.43878580729177pt, rp7_item_p008_b002_2_body)
}
#let rp7_item_p008_b003_3_md = "任何因本协议引起的或与之相关的争议、纠纷或索赔，包括对本协议的违反、终止或无效，均应依据《2020年第2号仲裁法》（Arbitration Act, Act No. 2 of 2020）通过仲裁解决。仲裁地点为达累斯萨拉姆。若任一方对仲裁结果不满，可向有管辖权的适格法院寻求适当救济。"
#let rp7_item_p008_b003_3_body = block(width: 382.8284205118815pt, height: 71.807665608724pt)[#{ pdftr_fit_markdown(rp7_item_p008_b003_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 71.807665608724pt) }]
#context {
  place(top + left, dx: 106.58579483032227pt, dy: 293.8512025960286pt, rp7_item_p008_b003_3_body)
}
#let rp7_item_p008_b004_4_md = "16. 赔偿"
#let rp7_item_p008_b004_4_body = block(width: 76.0pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp7_item_p008_b004_4_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 76.0pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 95.02982966105144pt, dy: 379.1694124348958pt, rp7_item_p008_b004_4_body)
}
#let rp7_item_p008_b005_5_md = "15.1. 在法律允许的最大范围内，E-Plus 应就因 E-Plus 或其任何雇员或代理人在履行本协议项下服务过程中的任何过失或故意行为或不作为，或因任何与“服务”相关的行为或履行，所全部或部分引起的所有索赔、诉讼或责任主张，为客户进行辩护、赔偿并使其免受损害。"
#let rp7_item_p008_b005_5_body = block(width: 388.05610707600914pt, height: 61.43544108072916pt)[#{ pdftr_fit_markdown(rp7_item_p008_b005_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 61.43544108072916pt) }]
#context {
  place(top + left, dx: 123.655189259847pt, dy: 405.13612060546876pt, rp7_item_p008_b005_5_body)
}
#let rp7_item_p008_b006_6_md = "15.2. E-Plus 的辩护、赔偿并使客户免受损害义务，应就任何因以下原因全部或部分造成的人身伤害、疾病、死亡、财产损害或毁坏（包括由此导致的使用损失）所引起的索赔、损害、损失或费用（包括但不限于合理的律师费、诉讼费及上诉费用）而产生：E-Plus、E-Plus 直接或间接雇用的任何人、或为 E-Plus 的行为承担责任之任何人的任何过失或故意作为或不作为，或与相关服务有关的任何行为或履行，无论该等索赔、损害、损失或费用是否部分由本协议项下被赔偿方（包括客户）造成。"
#let rp7_item_p008_b006_6_body = block(width: 389.6646341959636pt, height: 108.11044189453133pt)[#{ pdftr_fit_markdown(rp7_item_p008_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 108.11044189453133pt) }]
#context {
  place(top + left, dx: 122.42763163248698pt, dy: 483.4412593587239pt, rp7_item_p008_b006_6_body)
}
#let rp7_item_p008_b007_7_md = "15.3. E-Plus 同意赔偿、辩护并使客户免受因 E-Plus 在本协议项下履行服务时未能获取相关法规而导致的任何及所有罚款和损失的损害。"
#let rp7_item_p008_b007_7_body = block(width: 387.6539728800455pt, height: 48.270698242187564pt)[#{ pdftr_fit_markdown(rp7_item_p008_b007_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 48.270698242187564pt) }]
#context {
  place(top + left, dx: 123.22130762736002pt, dy: 608.0012475585937pt, rp7_item_p008_b007_7_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 9, width: 596.0pt))
#let rp8_item_p009_b000_0_md = "特此为证，双方已于上述日期正式签署本文件。"
#let rp8_item_p009_b000_0_body = block(width: 395.2944646199544pt, height: 25.531617838541763pt)[#{ pdftr_fit_markdown(rp8_item_p009_b000_0_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 25.531617838541763pt) }]
#context {
  place(top + left, dx: 107.3371477762858pt, dy: 177.36321940104162pt, rp8_item_p009_b000_0_body)
}
#let rp8_item_p009_b001_1_md = "代表 CHINA HARBOUR ENGINEERING COMPANY LTD 签署"
#let rp8_item_p009_b001_1_body = block(width: 388.86037546793625pt, height: 9.973271484375005pt)[#{ pdftr_fit_markdown(rp8_item_p009_b001_1_md, max_size: 10.78pt, min_size: 9.98pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 9.973271484375005pt) }]
#context {
  place(top + left, dx: 109.28430506388347pt, dy: 215.91104899088538pt, rp8_item_p009_b001_1_body)
}
#let rp8_item_p009_b005_2_md = "见证人："
#let rp8_item_p009_b005_2_body = block(width: 53.081249999999955pt, height: 12.366875000000078pt)[#{ pdftr_fit_markdown(rp8_item_p009_b005_2_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 12.366875000000078pt) }]
#context {
  place(top + left, dx: 296.0105224609375pt, dy: 251.21223307291663pt, rp8_item_p009_b005_2_body)
}
#let rp8_item_p009_b006_3_md = "签署人"
#let rp8_item_p009_b006_3_body = block(width: 16.085232543945267pt, height: 9.175422770182308pt)[#{ pdftr_fit_markdown(rp8_item_p009_b006_3_md, max_size: 8.81pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.175422770182308pt) }]
#context {
  place(top + left, dx: 296.3068201700847pt, dy: 291.42792378743485pt, rp8_item_p009_b006_3_body)
}
#let rp8_item_p009_b007_4_md = "职务：..."
#let rp8_item_p009_b007_4_body = block(width: 67.15583089192705pt, height: 13.563676757812459pt)[#{ pdftr_fit_markdown(rp8_item_p009_b007_4_md, max_size: 13.03pt, min_size: 10.83pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.563676757812459pt) }]
#context {
  place(top + left, dx: 295.957607014974pt, dy: 312.3633235677083pt, rp8_item_p009_b007_4_body)
}
#let rp8_item_p009_b010_5_md = "日期：\\*.."
#let rp8_item_p009_b010_5_body = block(width: 41.821593983968086pt, height: 9.574375813802135pt)[#{ pdftr_fit_markdown(rp8_item_p009_b010_5_md, max_size: 9.2pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.574375813802135pt) }]
#context {
  place(top + left, dx: 85.33636233011882pt, dy: 360.6170479329427pt, rp8_item_p009_b010_5_body)
}
#let rp8_item_p009_b011_6_md = "日期："
#let rp8_item_p009_b011_6_body = block(width: 26.540624999999977pt, height: 12.36687500000005pt)[#{ pdftr_fit_markdown(rp8_item_p009_b011_6_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 12.36687500000005pt) }]
#context {
  place(top + left, dx: 294.8887858072917pt, dy: 360.2817724609375pt, rp8_item_p009_b011_6_body)
}
#let rp8_item_p009_b012_7_md = "兹代表EMERGENCY PLUS MEDICAL SERVICES TANZANIA LIMITED签署"
#let rp8_item_p009_b012_7_body = block(width: 402.9349466959635pt, height: 21.941250813802014pt)[#{ pdftr_fit_markdown(rp8_item_p009_b012_7_md, max_size: 11.72pt, min_size: 10.92pt, max_leading: 0.72em, min_leading: 0.64em, fit_height: 21.941250813802014pt) }]
#context {
  place(top + left, dx: 108.80810038248697pt, dy: 432.3101159667969pt, rp8_item_p009_b012_7_body)
}
#let rp8_item_p009_b013_8_md = "见证人。"
#let rp8_item_p009_b013_8_body = block(width: 52.679115804036485pt, height: 11.96794108072919pt)[#{ pdftr_fit_markdown(rp8_item_p009_b013_8_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072919pt) }]
#context {
  place(top + left, dx: 295.99993998209635pt, dy: 493.10473388671875pt, rp8_item_p009_b013_8_body)
}
#let rp8_item_p009_b014_9_md = "SusanNg’ong’a"
#let rp8_item_p009_b014_9_body = block(width: 64.34090118408204pt)[#{ set text(size: 11.11pt); set par(leading: 0.29em); cmarker.render(rp8_item_p009_b014_9_md, math: mitex) }]
#context {
  place(top + left, dx: 117.25284347534179pt, dy: 525.7704280598958pt, rp8_item_p009_b014_9_body)
}
#let rp8_item_p009_b016_10_md = "签署人"
#let rp8_item_p009_b016_10_body = block(width: 14.074571228027338pt, height: 8.776507975260415pt)[#{ pdftr_fit_markdown(rp8_item_p009_b016_10_md, max_size: 8.43pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.776507975260415pt) }]
#context {
  place(top + left, dx: 86.72265803019206pt, dy: 532.8960274251302pt, rp8_item_p009_b016_10_body)
}
#let rp8_item_p009_b017_11_md = "总经理"
#let rp8_item_p009_b017_11_body = block(width: 75.19843750000001pt, height: 11.967941080729133pt)[#{ pdftr_fit_markdown(rp8_item_p009_b017_11_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967941080729133pt) }]
#context {
  place(top + left, dx: 146.74595540364584pt, dy: 547.8517228190104pt, rp8_item_p009_b017_11_body)
}
#let rp8_item_p009_b018_12_md = "财务与行政主管"
#let rp8_item_p009_b018_12_body = block(width: 152.0053731282552pt, height: 11.56900716145833pt)[#{ pdftr_fit_markdown(rp8_item_p009_b018_12_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.56900716145833pt) }]
#context {
  place(top + left, dx: 363.80128885904946pt, dy: 547.4145930989583pt, rp8_item_p009_b018_12_body)
}
#let rp8_item_p009_b019_13_md = "职务:.."
#let rp8_item_p009_b019_13_body = block(width: 66.35155766805013pt, height: 11.96794108072902pt)[#{ pdftr_fit_markdown(rp8_item_p009_b019_13_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072902pt) }]
#context {
  place(top + left, dx: 86.40518684387206pt, dy: 554.6420467122397pt, rp8_item_p009_b019_13_body)
}
#let rp8_item_p009_b020_14_md = "职务："
#let rp8_item_p009_b020_14_body = block(width: 58.308955891927155pt, height: 11.96794108072902pt)[#{ pdftr_fit_markdown(rp8_item_p009_b020_14_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072902pt) }]
#context {
  place(top + left, dx: 295.3014953613281pt, dy: 555.4908422851563pt, rp8_item_p009_b020_14_body)
}
#let rp8_item_p009_b022_15_md = "签名.."
#let rp8_item_p009_b022_15_body = block(width: 29.355535380045566pt, height: 11.569007161458444pt)[#{ pdftr_fit_markdown(rp8_item_p009_b022_15_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.569007161458444pt) }]
#context {
  place(top + left, dx: 86.27820053100587pt, dy: 577.9710302734375pt, rp8_item_p009_b022_15_body)
}
#let rp8_item_p009_b023_16_md = "签名"
#let rp8_item_p009_b023_16_body = block(width: 21.312938435872468pt, height: 10.372205403645694pt)[#{ pdftr_fit_markdown(rp8_item_p009_b023_16_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.372205403645694pt) }]
#context {
  place(top + left, dx: 295.59779307047523pt, dy: 579.6304256184897pt, rp8_item_p009_b023_16_body)
}
#let rp8_item_p009_b025_17_md = "日期：2026年3月30日"
#let rp8_item_p009_b025_17_body = block(width: 99.72841567993163pt, height: 9.175403645833399pt)[#{ pdftr_fit_markdown(rp8_item_p009_b025_17_md, max_size: 8.81pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.175403645833399pt) }]
#context {
  place(top + left, dx: 86.86022605895997pt, dy: 601.6607926432291pt, rp8_item_p009_b025_17_body)
}
#let rp8_item_p009_b026_18_md = "日期:....."
#let rp8_item_p009_b026_18_body = block(width: 42.22372334798172pt, height: 11.56904541015615pt)[#{ pdftr_fit_markdown(rp8_item_p009_b026_18_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.56904541015615pt) }]
#context {
  place(top + left, dx: 295.30149892171227pt, dy: 603.0103381347657pt, rp8_item_p009_b026_18_body)
}
#let rp8_item_p009_b027_19_md = "2026年3月30日"
#let rp8_item_p009_b027_19_body = block(width: 44.63650919596347pt, height: 9.574337565104315pt)[#{ pdftr_fit_markdown(rp8_item_p009_b027_19_md, max_size: 9.2pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.574337565104315pt) }]
#context {
  place(top + left, dx: 367.32519836425786pt, dy: 600.4003312174478pt, rp8_item_p009_b027_19_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 10, width: 596.0pt))
#let rp9_item_p010_b000_0_md = "1. 工作总体范围"
#let rp9_item_p010_b000_0_body = block(width: 130.89pt, height: 13.4pt)[#{ pdftr_fit_single_line_markdown(rp9_item_p010_b000_0_md, max_size: 12.26pt, min_size: 10.06pt, fit_width: 130.89pt, fit_height: 13.4pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.99361317952474pt, dy: 212.81378580729165pt, rp9_item_p010_b000_0_body)
}
#let rp9_item_p010_b001_1_md = "适用于患者转运的救护车应合理部署在达累斯萨拉姆市内。"
#let rp9_item_p010_b001_1_body = block(width: 342.2132242838542pt, height: 23.93588216145838pt)[#{ pdftr_fit_markdown(rp9_item_p010_b001_1_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 23.93588216145838pt) }]
#context {
  place(top + left, dx: 171.55106201171873pt, dy: 238.42520670572912pt, rp9_item_p010_b001_1_body)
}
#let rp9_item_p010_b002_2_md = "每辆救护车配备足够数量的工作人员，且经过患者转运流程的适当培训。"
#let rp9_item_p010_b002_2_body = block(width: 341.81109008789053pt, height: 24.33481608072907pt)[#{ pdftr_fit_markdown(rp9_item_p010_b002_2_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.33481608072907pt) }]
#context {
  place(top + left, dx: 171.54047953287758pt, dy: 274.9359244791667pt, rp9_item_p010_b002_2_body)
}
#let rp9_item_p010_b003_3_md = "感染控制知识和个人防护装备的正确使用可降低患者转运过程中患者和工作人员的风险。"
#let rp9_item_p010_b003_3_body = block(width: 342.61534881591797pt, height: 24.334816080729183pt)[#{ pdftr_fit_markdown(rp9_item_p010_b003_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729183pt) }]
#context {
  place(top + left, dx: 171.13835525512695pt, dy: 312.7070833333333pt, rp9_item_p010_b003_3_body)
}
#let rp9_item_p010_b004_4_md = "转运患者期间发生心脏骤停时，生命抢救服务所需的最低培训（ACLS/BLS）。"
#let rp9_item_p010_b004_4_body = block(width: 341.0068216959635pt, height: 24.733749999999986pt)[#{ pdftr_fit_markdown(rp9_item_p010_b004_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.733749999999986pt) }]
#context {
  place(top + left, dx: 172.36591288248698pt, dy: 350.9153922526042pt, rp9_item_p010_b004_4_body)
}
#let rp9_item_p010_b005_5_md = "要求在患者转运期间提供必要的物品储备。"
#let rp9_item_p010_b005_5_body = block(width: 341.4089558919271pt, height: 23.13801432291666pt)[#{ pdftr_fit_markdown(rp9_item_p010_b005_5_md, max_size: 11.72pt, min_size: 10.92pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.13801432291666pt) }]
#context {
  place(top + left, dx: 172.37649536132812pt, dy: 387.78682779947917pt, rp9_item_p010_b005_5_body)
}
#let rp9_item_p010_b006_6_md = "设备："
#let rp9_item_p010_b006_6_body = block(width: 67.96008961995443pt, height: 13.164742838541656pt)[#{ pdftr_fit_markdown(rp9_item_p010_b006_6_md, max_size: 12.65pt, min_size: 10.45pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.164742838541656pt) }]
#context {
  place(top + left, dx: 116.92478612263997pt, dy: 425.6640885416667pt, rp9_item_p010_b006_6_body)
}
#let rp9_item_p010_b007_7_md = "不同尺寸的基础和高级气道控制设备，包括但不限于口咽通气道、鼻咽通气道、气管插管（ETT）和喉罩（LMA）、喉镜手柄和镜片，以及其他插管设备。"
#let rp9_item_p010_b007_7_body = block(width: 372.7751525878906pt, height: 15.710757161458318pt)[#{ pdftr_fit_markdown(rp9_item_p010_b007_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 15.710757161458318pt) }]
#context {
  place(top + left, dx: 139.7615732828776pt, dy: 451.44188313802084pt, rp9_item_p010_b007_7_body)
}
#let rp9_item_p010_b008_8_md = "供氧设备，包括合适尺寸的鼻导管、面罩、非再呼吸面罩"
#let rp9_item_p010_b008_8_body = block(width: 371.56875pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b008_8_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 140.153125pt, dy: 539.4944020507813pt, rp9_item_p010_b008_8_body)
}
#let rp9_item_p010_b009_9_md = "吸引设备和导管（柔性/刚性）"
#let rp9_item_p010_b009_9_body = block(width: 193.42486673990888pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b009_9_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 135.041828918457pt, dy: 509.90265836588543pt, rp9_item_p010_b009_9_body)
}
#let rp9_item_p010_b010_10_md = "不同尺寸的带储气袋的BVM设备"
#let rp9_item_p010_b010_10_body = block(width: 221.57400919596353pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b010_10_md, max_size: 13.41pt, min_size: 11.21pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 135.7825958251953pt, dy: 583.6631130208333pt, rp9_item_p010_b010_10_body)
}
#let rp9_item_p010_b011_11_md = "各种尺寸的静脉留置针、针头、骨髓穿刺针"
#let rp9_item_p010_b011_11_body = block(width: 301.5980183919271pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b011_11_md, max_size: 11.4pt, min_size: 10.6pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 138.73508911132814pt, dy: 644.9297380859376pt, rp9_item_p010_b011_11_body)
}
#let rp9_item_p010_b012_12_md = "脉搏血氧仪及儿童探头"
#let rp9_item_p010_b012_12_body = block(width: 158.4395009358724pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b012_12_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 134.12116139729818pt, dy: 615.6435583658855pt, rp9_item_p010_b012_12_body)
}
#let rp9_item_p010_b013_13_md = "药物（肾上腺素、阿托品、10%葡萄糖、葡萄糖酸钙、抗惊厥药）和液体"
#let rp9_item_p010_b013_13_body = block(width: 372.37300872802734pt, height: 17.13805257161448pt)[#{ pdftr_fit_markdown(rp9_item_p010_b013_13_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.74em, min_leading: 0.66em, fit_height: 17.13805257161448pt) }]
#context {
  place(top + left, dx: 139.32770156860352pt, dy: 677.493080777995pt, rp9_item_p010_b013_13_body)
}
#let rp9_item_p010_b014_14_md = "手动除颤器或具备儿童功能的AED（电极片和电缆）"
#let rp9_item_p010_b014_14_body = block(width: 311.6512959798177pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b014_14_md, max_size: 11.56pt, min_size: 10.76pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 138.15305074055988pt, dy: 702.6639914225262pt, rp9_item_p010_b014_14_body)
}
#let rp9_item_p010_b015_15_md = "新生儿转运培养箱"
#let rp9_item_p010_b015_15_body = block(width: 147.58195495605466pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b015_15_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 134.68203481038412pt, dy: 770.2525029459636pt, rp9_item_p010_b015_15_body)
}
#let rp9_item_p010_b016_16_md = "运输呼吸机（配有儿科管路及设置）"
#let rp9_item_p010_b016_16_body = block(width: 239.66988372802734pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b016_16_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 135.83551406860352pt, dy: 736.0392557454429pt, rp9_item_p010_b016_16_body)
}
#let rp9_item_p010_b017_17_md = "软颈托/适当尺寸的颈椎及骨折固定装置/设备"
#let rp9_item_p010_b017_17_body = block(width: 371.1666158040365pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b017_17_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 139.719243367513pt, dy: 794.5553548502605pt, rp9_item_p010_b017_17_body)
}
#let rp9_item_p010_b018_18_md = "儿科和新生儿血压袖带"
#let rp9_item_p010_b018_18_body = block(width: 137.5286966959636pt, height: 11.170073242187527pt)[#{ pdftr_fit_markdown(rp9_item_p010_b018_18_md, max_size: 10.73pt, min_size: 8.53pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.170073242187527pt) }]
#context {
  place(top + left, dx: 131.45440165201822pt, dy: 869.0830217773441pt, rp9_item_p010_b018_18_body)
}
#let rp9_item_p010_b019_19_md = "儿科听诊器"
#let rp9_item_p010_b019_19_body = block(width: 93.6964365641276pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp9_item_p010_b019_19_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 131.14751942952475pt, dy: 839.8605017252605pt, rp9_item_p010_b019_19_body)
}
#let rp9_item_p010_b020_20_md = "附件1"
#let rp9_item_p010_b020_20_body = block(width: 71.36pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp9_item_p010_b020_20_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 71.36pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 276.08387451171876pt, dy: 162.3471052042643pt, rp9_item_p010_b020_20_body)
}
#let rp9_item_p010_b021_21_md = "工作范围"
#let rp9_item_p010_b021_21_body = block(width: 96.27pt, height: 10.89pt)[#{ pdftr_fit_single_line_markdown(rp9_item_p010_b021_21_md, max_size: 9.96pt, min_size: 7.76pt, fit_width: 96.27pt, fit_height: 10.89pt, weight: "bold") }]
#context {
  place(top + left, dx: 264.43268127441405pt, dy: 188.66688313802086pt, rp9_item_p010_b021_21_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 11, width: 596.0pt))
#let rp10_item_p011_b000_0_md = "附件二"
#let rp10_item_p011_b000_0_body = block(width: 71.78pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp10_item_p011_b000_0_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 71.78pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 276.94105529785156pt, dy: 177.20093648274744pt, rp10_item_p011_b000_0_body)
}
#let rp10_item_p011_b001_1_md = "救护车设备清单"
#let rp10_item_p011_b001_1_body = block(width: 191.7pt, height: 10.89pt)[#{ pdftr_fit_single_line_markdown(rp10_item_p011_b001_1_md, max_size: 9.96pt, min_size: 7.76pt, fit_width: 191.7pt, fit_height: 10.89pt, weight: "bold") }]
#context {
  place(top + left, dx: 219.4152028401693pt, dy: 203.0963067626953pt, rp10_item_p011_b001_1_body)
}
#let rp10_item_p011_b002_2_md = "E-Plus 应向客户的患者提供救护车、紧急医疗运输服务及撤离服务，包括以下设备："
#let rp10_item_p011_b002_2_body = block(width: 404.14134928385425pt, height: 23.53694824218752pt)[#{ pdftr_fit_markdown(rp10_item_p011_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.53694824218752pt) }]
#context {
  place(top + left, dx: 108.41654866536459pt, dy: 229.50018229166662pt, rp10_item_p011_b002_2_body)
}
#let rp10_item_p011_b003_3_md = "1. 自动体外除颤器"
#let rp10_item_p011_b003_3_body = block(width: 163.26506296793622pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b003_3_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.85611089070638pt, dy: 266.05332194010424pt, rp10_item_p011_b003_3_body)
}
#let rp10_item_p011_b004_4_md = "2.脉搏血氧仪"
#let rp10_item_p011_b004_4_body = block(width: 85.25169576009112pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b004_4_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 116.95653940836588pt, dy: 293.62017415364573pt, rp10_item_p011_b004_4_body)
}
#let rp10_item_p011_b005_5_md = "机械呼吸机"
#let rp10_item_p011_b005_5_body = block(width: 114.60725046793621pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b005_5_md, max_size: 13.41pt, min_size: 11.21pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.57564214070638pt, dy: 321.250686035156pt, rp10_item_p011_b005_5_body)
}
#let rp10_item_p011_b006_6_md = "便携式呼吸机"
#let rp10_item_p011_b006_6_body = block(width: 98.52202758789062pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b006_6_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.57563578287761pt, dy: 353.15473977864553pt, rp10_item_p011_b006_6_body)
}
#let rp10_item_p011_b007_7_md = "KED（肯德里克解脱装置）"
#let rp10_item_p011_b007_7_body = block(width: 180.95880330403645pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b007_7_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 120.74502461751302pt, dy: 366.32372171223926pt, rp10_item_p011_b007_7_body)
}
#let rp10_item_p011_b008_8_md = "气道管理套件"
#let rp10_item_p011_b008_8_body = block(width: 122.64986673990886pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b008_8_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.63387807210286pt, dy: 379.4799717122393pt, rp10_item_p011_b008_8_body)
}
#let rp10_item_p011_b009_9_md = "血糖仪"
#let rp10_item_p011_b009_9_body = block(width: 67.9600799560547pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b009_9_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.19467315673828pt, dy: 404.32832636718723pt, rp10_item_p011_b009_9_body)
}
#let rp10_item_p011_b010_10_md = "电动吸引器"
#let rp10_item_p011_b010_10_body = block(width: 130.6924830118815pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b010_10_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.57563858032228pt, dy: 431.85698277994766pt, rp10_item_p011_b010_10_body)
}
#let rp10_item_p011_b011_11_md = "9. 牵引夹板"
#let rp10_item_p011_b011_11_body = block(width: 87.26234741210936pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b011_11_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 117.00945129394532pt, dy: 444.20263300781227pt, rp10_item_p011_b011_11_body)
}
#let rp10_item_p011_b012_12_md = "脊柱板"
#let rp10_item_p011_b012_12_body = block(width: 70.37287546793621pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b012_12_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 117.41157964070638pt, dy: 471.76948644205703pt, rp10_item_p011_b012_12_body)
}
#let rp10_item_p011_b013_13_md = "11.铲式担架"
#let rp10_item_p011_b013_13_body = block(width: 83.24104410807293pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b013_13_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.59680379231771pt, dy: 485.7363362141924pt, rp10_item_p011_b013_13_body)
}
#let rp10_item_p011_b014_14_md = "12.氧气瓶及配套面罩"
#let rp10_item_p011_b014_14_body = block(width: 186.18650919596354pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b014_14_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 120.88259582519532pt, dy: 510.58473033854136pt, rp10_item_p011_b014_14_body)
}
#let rp10_item_p011_b015_15_md = "13. 担架及一套绑带"
#let rp10_item_p011_b015_15_body = block(width: 146.77769622802737pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b015_15_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.42223281860352pt, dy: 538.1643144856769pt, rp10_item_p011_b015_15_body)
}
#let rp10_item_p011_b016_16_md = "14. 基本敷料包"
#let rp10_item_p011_b016_16_body = block(width: 102.94545542399091pt, height: 11.967941080729133pt)[#{ pdftr_fit_markdown(rp10_item_p011_b016_16_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967941080729133pt) }]
#context {
  place(top + left, dx: 118.26875279744466pt, dy: 566.6330325520831pt, rp10_item_p011_b016_16_body)
}
#let rp10_item_p011_b017_17_md = "16. 袋阀面罩 (BVM)"
#let rp10_item_p011_b017_17_body = block(width: 127.87756296793619pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b017_17_md, max_size: 10.73pt, min_size: 8.53pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.50156173706056pt, dy: 590.7980797526039pt, rp10_item_p011_b017_17_body)
}
#let rp10_item_p011_b019_18_md = "17. 上下肢夹板"
#let rp10_item_p011_b019_18_body = block(width: 160.45014292399088pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp10_item_p011_b019_18_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.78203404744465pt, dy: 603.5426638997395pt, rp10_item_p011_b019_18_body)
}
#let rp10_item_p011_b020_19_md = "18.颈托"
#let rp10_item_p011_b020_19_body = block(width: 84.84957122802734pt, height: 10.372205403645921pt)[#{ pdftr_fit_markdown(rp10_item_p011_b020_19_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.372205403645921pt) }]
#context {
  place(top + left, dx: 117.79254531860352pt, dy: 630.1438225260415pt, rp10_item_p011_b020_19_body)
}
#let rp10_item_p011_b022_20_md = "20. 插管套件"
#let rp10_item_p011_b022_20_body = block(width: 75.60057169596354pt, height: 10.771177571614544pt)[#{ pdftr_fit_markdown(rp10_item_p011_b022_20_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.771177571614544pt) }]
#context {
  place(top + left, dx: 117.97243957519532pt, dy: 655.1958623209634pt, rp10_item_p011_b022_20_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 12, width: 596.0pt))
#let rp11_item_p012_b000_0_md = "附件3"
#let rp11_item_p012_b000_0_body = block(width: 72.2pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp11_item_p012_b000_0_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 72.2pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 275.25846099853516pt, dy: 178.89852701822915pt, rp11_item_p012_b000_0_body)
}
#let rp11_item_p012_b001_1_md = "服务费率"
#let rp11_item_p012_b001_1_body = block(width: 198.45pt, height: 12.15pt)[#{ pdftr_fit_single_line_markdown(rp11_item_p012_b001_1_md, max_size: 11.11pt, min_size: 8.91pt, fit_width: 198.45pt, fit_height: 12.15pt, weight: "bold") }]
#context {
  place(top + left, dx: 214.08167215983073pt, dy: 203.07450256347656pt, rp11_item_p012_b001_1_body)
}
#let rp11_item_p012_b003_2_md = "描述"
#let rp11_item_p012_b003_2_body = block(width: 55.89616038004557pt, height: 12.366874999999993pt)[#{ pdftr_fit_markdown(rp11_item_p012_b003_2_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 12.366874999999993pt) }]
#context {
  place(top + left, dx: 61.15561345418294pt, dy: 229.9924658203125pt, rp11_item_p012_b003_2_body)
}
#let rp11_item_p012_b004_3_md = "费率"
#let rp11_item_p012_b004_3_body = block(width: 25.334222412109398pt, height: 11.569026285807297pt)[#{ pdftr_fit_markdown(rp11_item_p012_b004_3_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.569026285807297pt) }]
#context {
  place(top + left, dx: 393.90818583170574pt, dy: 229.54260477701823pt, rp11_item_p012_b004_3_body)
}
#let rp11_item_p012_b005_4_md = "1. 在我们位于达累斯萨拉姆的救护站30公里范围内，为稳定患者提供的地面救护车服务"
#let rp11_item_p012_b005_4_body = block(width: 278.67658182779945pt, height: 24.33481608072924pt)[#{ pdftr_fit_markdown(rp11_item_p012_b005_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.33481608072924pt) }]
#context {
  place(top + left, dx: 84.37336883544923pt, dy: 257.9601147460937pt, rp11_item_p012_b005_4_body)
}
#let rp11_item_p012_b007_5_md = "2. 距达累斯萨拉姆救护站30公里范围内插管患者的地面救护车服务"
#let rp11_item_p012_b007_5_body = block(width: 292.7511240641277pt, height: 22.340165608723964pt)[#{ pdftr_fit_markdown(rp11_item_p012_b007_5_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.72em, min_leading: 0.64em, fit_height: 22.340165608723964pt) }]
#context {
  place(top + left, dx: 84.32045237223306pt, dy: 292.27245259602864pt, rp11_item_p012_b007_5_body)
}
#let rp11_item_p012_b009_6_md = "3. 从/至朱利叶斯·尼雷尔国际机场转运（稳定患者）"
#let rp11_item_p012_b009_6_body = block(width: 284.7085126241048pt, height: 23.138014322916717pt)[#{ pdftr_fit_markdown(rp11_item_p012_b009_6_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.138014322916717pt) }]
#context {
  place(top + left, dx: 83.68551063537598pt, dy: 317.761640625pt, rp11_item_p012_b009_6_body)
}
#let rp11_item_p012_b011_7_md = "4. 每小时等待费用"
#let rp11_item_p012_b011_7_body = block(width: 127.47542877197266pt, height: 13.962610677083376pt)[#{ pdftr_fit_markdown(rp11_item_p012_b011_7_md, max_size: 13.41pt, min_size: 11.21pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.962610677083376pt) }]
#context {
  place(top + left, dx: 79.12450383504232pt, dy: 354.8155696614583pt, rp11_item_p012_b011_7_body)
}
#let rp11_item_p012_b013_8_md = "5. 每公里附加费用"
#let rp11_item_p012_b013_8_body = block(width: 137.52869669596353pt, height: 11.96794108072919pt)[#{ pdftr_fit_markdown(rp11_item_p012_b013_8_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072919pt) }]
#context {
  place(top + left, dx: 80.23565165201822pt, dy: 379.79121663411456pt, rp11_item_p012_b013_8_body)
}
#let rp11_item_p012_b015_9_md = "6. 距我方所在地30公里范围内活动的备用救护车服务（体育赛事、会议、社交活动）"
#let rp11_item_p012_b015_9_body = block(width: 282.6978802998861pt, height: 24.733749999999986pt)[#{ pdftr_fit_markdown(rp11_item_p012_b015_9_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.733749999999986pt) }]
#context {
  place(top + left, dx: 83.63259925842284pt, dy: 403.9647900390625pt, rp11_item_p012_b015_9_body)
}
#let rp11_item_p012_b016_10_md = "每辆救护车 TZS 400,000"
#let rp11_item_p012_b016_10_body = block(width: 66.75369669596347pt, height: 23.536948242187464pt)[#{ pdftr_fit_markdown(rp11_item_p012_b016_10_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.57em, min_leading: 0.37em, fit_height: 23.536948242187464pt) }]
#context {
  place(top + left, dx: 394.1515736897787pt, dy: 404.77538981119795pt, rp11_item_p012_b016_10_body)
}
#let rp11_item_p012_b017_11_md = "7. 参与我方所在地30公里范围内的演练演习。"
#let rp11_item_p012_b017_11_body = block(width: 285.11065165201825pt, height: 11.56900716145833pt)[#{ pdftr_fit_markdown(rp11_item_p012_b017_11_md, max_size: 11.1pt, min_size: 10.3pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 11.56900716145833pt) }]
#context {
  place(top + left, dx: 84.54268646240234pt, dy: 437.49625813802083pt, rp11_item_p012_b017_11_body)
}
#let rp11_item_p012_b018_12_md = "每辆救护车 TZS 400,000"
#let rp11_item_p012_b018_12_body = block(width: 66.3515625pt, height: 23.93588216145838pt)[#{ pdftr_fit_markdown(rp11_item_p012_b018_12_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.59em, min_leading: 0.39em, fit_height: 23.93588216145838pt) }]
#context {
  place(top + left, dx: 394.5642903645833pt, dy: 437.8909456380208pt, rp11_item_p012_b018_12_body)
}
