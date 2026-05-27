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
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 6, width: 596.0pt))
#let rp0_item_p006_b000_0_md = "或职业。E-Plus应对员工绩效、许可和行为负责。"
#let rp0_item_p006_b000_0_body = block(width: 340.20256296793616pt, height: 25.531617838541635pt)[#{ pdftr_fit_markdown(rp0_item_p006_b000_0_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 25.531617838541635pt) }]
#context {
  place(top + left, dx: 172.76803716023764pt, dy: 115.40152913411463pt, rp0_item_p006_b000_0_body)
}
#let rp0_item_p006_b001_1_md = "5. 完整协议："
#let rp0_item_p006_b001_1_body = block(width: 108.51pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p006_b001_1_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 108.51pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.85603612263998pt, dy: 178.45232503255212pt, rp0_item_p006_b001_1_body)
}
#let rp0_item_p006_b002_2_md = "本协议构成双方就本协议所涉事项达成的完整协议与谅解。"
#let rp0_item_p006_b002_2_body = block(width: 370.76449127197264pt, height: 22.73909952799488pt)[#{ pdftr_fit_markdown(rp0_item_p006_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 22.73909952799488pt) }]
#context {
  place(top + left, dx: 141.82514673868815pt, dy: 203.58659647623693pt, rp0_item_p006_b002_2_body)
}
#let rp0_item_p006_b003_3_md = "6. 无弃权："
#let rp0_item_p006_b003_3_body = block(width: 74.74pt, height: 11.73pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p006_b003_3_md, max_size: 10.73pt, min_size: 8.53pt, fit_width: 74.74pt, fit_height: 11.73pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.43274408976237pt, dy: 240.4285514322916pt, rp0_item_p006_b003_3_body)
}
#let rp0_item_p006_b004_4_md = "对本协议的任何变更，除非由一方向另一方书面作出，否则无效。"
#let rp0_item_p006_b004_4_body = block(width: 371.1666254679362pt, height: 24.334835205078093pt)[#{ pdftr_fit_markdown(rp0_item_p006_b004_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334835205078093pt) }]
#context {
  place(top + left, dx: 141.41243006388348pt, dy: 266.02361226399734pt, rp0_item_p006_b004_4_body)
}
#let rp0_item_p006_b005_5_md = "7. 终止："
#let rp0_item_p006_b005_5_body = block(width: 76.42pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p006_b005_5_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 76.42pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 118.32166188557943pt, dy: 304.94387674967453pt, rp0_item_p006_b005_5_body)
}
#let rp0_item_p006_b006_6_md = "任何一方可因另一方未能实质性地履行（启动终止的一方）而终止本协议。此外，客户拥有绝对权利，无需理由、为方便而随时暂停或终止本协议，只需提前三十(30)日书面通知E-Plus。"
#let rp0_item_p006_b006_6_body = block(width: 372.37299906412755pt, height: 57.04720621744781pt)[#{ pdftr_fit_markdown(rp0_item_p006_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 57.04720621744781pt) }]
#context {
  place(top + left, dx: 142.29076487223307pt, dy: 331.5757010904949pt, rp0_item_p006_b006_6_body)
}
#let rp0_item_p006_b007_7_md = "8. 通知:"
#let rp0_item_p006_b007_7_body = block(width: 54.05pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p006_b007_7_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 54.05pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.33749643961589pt, dy: 404.2305639648437pt, rp0_item_p006_b007_7_body)
}
#let rp0_item_p006_b008_8_md = "根据本协议一方向另一方发出的任何通知，均应以书面形式或通过电报、传真或电子邮件发送，并随后以书面形式确认送达以下地址。"
#let rp0_item_p006_b008_8_body = block(width: 371.970864868164pt, height: 35.10595540364591pt)[#{ pdftr_fit_markdown(rp0_item_p006_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 35.10595540364591pt) }]
#context {
  place(top + left, dx: 143.12678070068358pt, dy: 431.03271565755205pt, rp0_item_p006_b008_8_body)
}
#let rp0_item_p006_b014_9_md = "董事总经理"
#let rp0_item_p006_b014_9_body = block(width: 84.84958089192708pt, height: 11.967979329426953pt)[#{ pdftr_fit_markdown(rp0_item_p006_b014_9_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967979329426953pt) }]
#context {
  place(top + left, dx: 90.27833455403646pt, dy: 530.4514961751303pt, rp0_item_p006_b014_9_body)
}
#let rp0_item_p006_b015_10_md = "施工经理"
#let rp0_item_p006_b015_10_body = block(width: 98.11989339192706pt, height: 12.76580891927074pt)[#{ pdftr_fit_markdown(rp0_item_p006_b015_10_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 12.76580891927074pt) }]
#context {
  place(top + left, dx: 299.7355041503906pt, dy: 528.3550105794271pt, rp0_item_p006_b015_10_body)
}
#let rp0_item_p006_b026_11_md = "9. 质量控制："
#let rp0_item_p006_b026_11_body = block(width: 95.85pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p006_b026_11_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 95.85pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 107.37947642008464pt, dy: 658.4214469401041pt, rp0_item_p006_b026_11_body)
}
#let rp0_item_p006_b027_12_md = "救护车服务质量将通过客户指定机构进行的定期抽查与审计予以监督。E-Plus 负责按季度收集、监测客户反馈并据此采取行动，同时将相关报告提交客户主管机构。确保员工资质/执照处于最新状态、设备库存与物资管理、车辆牌照等事宜由 E-Plus 承担。然而，在本协议生效时以及协议期内每当相关证件更新或指派人员发生变动时，客户应获得 E-Plus 及其员工资质/执照的副本。"
#let rp0_item_p006_b027_12_body = block(width: 371.9708745320637pt, height: 35.50488932291671pt)[#{ pdftr_fit_markdown(rp0_item_p006_b027_12_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 35.50488932291671pt) }]
#context {
  place(top + left, dx: 143.97336908976237pt, dy: 685.6825325520833pt, rp0_item_p006_b027_12_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 7, width: 596.0pt))
#let rp1_item_p007_b000_0_md = "10. 授权代表"
#let rp1_item_p007_b000_0_body = block(width: 153.69pt, height: 12.15pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p007_b000_0_md, max_size: 11.11pt, min_size: 8.91pt, fit_width: 153.69pt, fit_height: 12.15pt, weight: "bold") }]
#context {
  place(top + left, dx: 102.47982711791992pt, dy: 192.8890167236328pt, rp1_item_p007_b000_0_body)
}
#let rp1_item_p007_b006_1_md = "董事总经理"
#let rp1_item_p007_b006_1_body = block(width: 84.04530766805013pt, height: 13.164742838541713pt)[#{ pdftr_fit_markdown(rp1_item_p007_b006_1_md, max_size: 12.65pt, min_size: 10.45pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.164742838541713pt) }]
#context {
  place(top + left, dx: 76.28842455546061pt, dy: 262.2719580078125pt, rp1_item_p007_b006_1_body)
}
#let rp1_item_p007_b007_2_md = "施工经理"
#let rp1_item_p007_b007_2_body = block(width: 97.31562499999995pt, height: 11.569007161458273pt)[#{ pdftr_fit_markdown(rp1_item_p007_b007_2_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.569007161458273pt) }]
#context {
  place(top + left, dx: 285.74558919270834pt, dy: 261.37225504557296pt, rp1_item_p007_b007_2_body)
}
#let rp1_item_p007_b014_3_md = "11. 质量改进与患者安全方面及监测"
#let rp1_item_p007_b014_3_body = block(width: 333.57pt, height: 12.15pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p007_b014_3_md, max_size: 11.11pt, min_size: 8.91pt, fit_width: 333.57pt, fit_height: 12.15pt, weight: "bold") }]
#context {
  place(top + left, dx: 111.22088419596354pt, dy: 338.88096008300784pt, rp1_item_p007_b014_3_body)
}
#let rp1_item_p007_b015_4_md = "E-Plus 必须确保遵守当地法规、国际标准及组织规定，以提供最佳服务与实践。患者、访客及员工的安全保障须始终得到落实。危及质量、安全与保障可能对合同条款产生严重影响。员工资质、知识、持续培训、岗位说明书、职业着装、身份识别卡以及感染防控措施（即标准预防、废物管理等）是质量保证的关键要素。每季度应开展绩效监测与报告，内容包括客户满意度、反馈、充分性监测以及不符合项的关闭响应。E-Plus 有责任在出现任何不符合项时提交行动计划。合同续签将基于上述绩效指标以及客户相关部门的绩效评估。"
#let rp1_item_p007_b015_4_body = block(width: 373.17729644775386pt, height: 142.0195955403646pt)[#{ pdftr_fit_markdown(rp1_item_p007_b015_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 142.0195955403646pt) }]
#context {
  place(top + left, dx: 141.04204330444335pt, dy: 367.8148075358073pt, rp1_item_p007_b015_4_body)
}
#let rp1_item_p007_b016_5_md = "12. 管辖法律"
#let rp1_item_p007_b016_5_body = block(width: 109.78pt, height: 11.73pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p007_b016_5_md, max_size: 10.73pt, min_size: 8.53pt, fit_width: 109.78pt, fit_height: 11.73pt, weight: "bold") }]
#context {
  place(top + left, dx: 102.22585678100586pt, dy: 527.3196850585938pt, rp1_item_p007_b016_5_body)
}
#let rp1_item_p007_b017_6_md = "本协议应受坦桑尼亚联合共和国法律管辖并据其解释。"
#let rp1_item_p007_b017_6_body = block(width: 371.5687693277995pt, height: 24.334816080729183pt)[#{ pdftr_fit_markdown(rp1_item_p007_b017_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729183pt) }]
#context {
  place(top + left, dx: 142.6929000854492pt, dy: 552.4903474934896pt, rp1_item_p007_b017_6_body)
}
#let rp1_item_p007_b018_7_md = "13. 无合资或合伙关系"
#let rp1_item_p007_b018_7_body = block(width: 187.9pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p007_b018_7_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 187.9pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 104.18359807332357pt, dy: 590.0938102213541pt, rp1_item_p007_b018_7_body)
}
#let rp1_item_p007_b019_8_md = "双方理解并同意，本协议中的任何内容均不得被视为或解释为在客户与 E-Plus 或任何其他方之间建立合伙或合资关系，也不得使任何一方以任何方式对另一方的债务和义务承担责任。"
#let rp1_item_p007_b019_8_body = block(width: 372.37302805582686pt, height: 48.27073649088538pt)[#{ pdftr_fit_markdown(rp1_item_p007_b019_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 48.27073649088538pt) }]
#context {
  place(top + left, dx: 141.86747665405272pt, dy: 618.1867142740886pt, rp1_item_p007_b019_8_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 8, width: 596.0pt))
#let rp2_item_p008_b000_0_md = "14. 不可抗力"
#let rp2_item_p008_b000_0_body = block(width: 106.83pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p008_b000_0_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 106.83pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 99.61200536092123pt, dy: 112.64926066080726pt, rp2_item_p008_b000_0_body)
}
#let rp2_item_p008_b001_1_md = "任何一方均不应被视为违反本协议，若其履行义务（付款义务除外）出现延迟或失败是由于超出其合理控制范围且非因其过错或疏忽所致的原因。为此目的，此类行为或事件应包括但不限于：暴风雨、洪水、极端恶劣天气、天灾、流行病、大流行病、抗议示威、战争、恐怖主义或恐怖行为、暴动、罢工、停工或其他产业骚乱或不可预见的现场条件。若此类行为或事件确实发生，双方应尽力克服由此产生的所有困难，并尽可能合理地尽快恢复本协议所规定服务的正常进行和日程安排。"
#let rp2_item_p008_b001_1_body = block(width: 373.17727711995434pt, height: 108.90829060872397pt)[#{ pdftr_fit_markdown(rp2_item_p008_b001_1_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 108.90829060872397pt) }]
#context {
  place(top + left, dx: 139.3488665262858pt, dy: 141.8286204020182pt, rp2_item_p008_b001_1_body)
}
#let rp2_item_p008_b002_2_md = "15. 争议解决"
#let rp2_item_p008_b002_2_body = block(width: 111.47pt, height: 13.4pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p008_b002_2_md, max_size: 12.26pt, min_size: 10.06pt, fit_width: 111.47pt, fit_height: 13.4pt, weight: "bold") }]
#context {
  place(top + left, dx: 96.34204915364583pt, dy: 265.43878580729177pt, rp2_item_p008_b002_2_body)
}
#let rp2_item_p008_b003_3_md = "因本协议产生或与之相关的任何争议、纠纷或索赔，或本协议的违约、终止或无效，均应依照2020年第2号《仲裁法》通过仲裁解决。仲裁地点为达累斯萨拉姆。任何一方如对仲裁结果不满意，均可向具有管辖权的适格法院寻求适当救济。"
#let rp2_item_p008_b003_3_body = block(width: 382.8284205118815pt, height: 71.807665608724pt)[#{ pdftr_fit_markdown(rp2_item_p008_b003_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 71.807665608724pt) }]
#context {
  place(top + left, dx: 106.58579483032227pt, dy: 293.8512025960286pt, rp2_item_p008_b003_3_body)
}
#let rp2_item_p008_b004_4_md = "16. 赔偿"
#let rp2_item_p008_b004_4_body = block(width: 76.0pt, height: 13.82pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p008_b004_4_md, max_size: 12.65pt, min_size: 10.45pt, fit_width: 76.0pt, fit_height: 13.82pt, weight: "bold") }]
#context {
  place(top + left, dx: 95.02982966105144pt, dy: 379.1694124348958pt, rp2_item_p008_b004_4_body)
}
#let rp2_item_p008_b005_5_md = "15.1. 在法律允许的最大范围内，E-Plus 应就所有因 E-Plus 或其任何员工或代理人在履行本协议项下服务过程中的任何疏忽或故意的作为或不作为，或与服务相关的任何行为或履行，所全部或部分引起的索赔、诉讼或责任主张，为客户进行辩护、赔偿并使客户免受损害。"
#let rp2_item_p008_b005_5_body = block(width: 388.05610707600914pt, height: 61.43544108072916pt)[#{ pdftr_fit_markdown(rp2_item_p008_b005_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 61.43544108072916pt) }]
#context {
  place(top + left, dx: 123.655189259847pt, dy: 405.13612060546876pt, rp2_item_p008_b005_5_body)
}
#let rp2_item_p008_b006_6_md = "15.2. E-Plus 的辩护、赔偿及使客户免受损害的义务，适用于因以下原因引起或与之相关的任何索赔、损害、损失或费用（包括但不限于合理的律师费、法庭费用及上诉程序费用）：由 E-Plus、E-Plus 直接或间接雇用的任何人、或 E-Plus 可能对其行为负责的任何人，因任何过失或故意行为或不作为，或因与《服务》相关的任何行为或履约，全部或部分造成的人身或身体伤害、疾病、患病、死亡、财产损害、减值或毁坏（包括由此造成的使用损失），无论该索赔、损害、损失或费用是否部分由本协议项下被赔偿方（包括客户）造成。"
#let rp2_item_p008_b006_6_body = block(width: 389.6646341959636pt, height: 108.11044189453133pt)[#{ pdftr_fit_markdown(rp2_item_p008_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 108.11044189453133pt) }]
#context {
  place(top + left, dx: 122.42763163248698pt, dy: 483.4412593587239pt, rp2_item_p008_b006_6_body)
}
#let rp2_item_p008_b007_7_md = "15.3. E-Plus 同意赔偿、辩护并使客户免受因 E-Plus 在履行本协议项下服务时未能取得相关法规所导致的任何及所有客户承担的罚金和损害赔偿。"
#let rp2_item_p008_b007_7_body = block(width: 387.6539728800455pt, height: 48.270698242187564pt)[#{ pdftr_fit_markdown(rp2_item_p008_b007_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 48.270698242187564pt) }]
#context {
  place(top + left, dx: 123.22130762736002pt, dy: 608.0012475585937pt, rp2_item_p008_b007_7_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 9, width: 596.0pt))
#let rp3_item_p009_b000_0_md = "兹证明，双方已于上文所载日期正式签署本文件。"
#let rp3_item_p009_b000_0_body = block(width: 395.2944646199544pt, height: 25.531617838541763pt)[#{ pdftr_fit_markdown(rp3_item_p009_b000_0_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 25.531617838541763pt) }]
#context {
  place(top + left, dx: 107.3371477762858pt, dy: 177.36321940104162pt, rp3_item_p009_b000_0_body)
}
#let rp3_item_p009_b001_1_md = "代表CHINA HARBOUR ENGINEERING COMPANY LTD签署"
#let rp3_item_p009_b001_1_body = block(width: 388.86037546793625pt, height: 9.973271484375005pt)[#{ pdftr_fit_markdown(rp3_item_p009_b001_1_md, max_size: 10.78pt, min_size: 9.98pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 9.973271484375005pt) }]
#context {
  place(top + left, dx: 109.28430506388347pt, dy: 215.91104899088538pt, rp3_item_p009_b001_1_body)
}
#let rp3_item_p009_b005_2_md = "见证人："
#let rp3_item_p009_b005_2_body = block(width: 53.081249999999955pt, height: 12.366875000000078pt)[#{ pdftr_fit_markdown(rp3_item_p009_b005_2_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 12.366875000000078pt) }]
#context {
  place(top + left, dx: 296.0105224609375pt, dy: 251.21223307291663pt, rp3_item_p009_b005_2_body)
}
#let rp3_item_p009_b006_3_md = "签署人"
#let rp3_item_p009_b006_3_body = block(width: 16.085232543945267pt, height: 9.175422770182308pt)[#{ pdftr_fit_markdown(rp3_item_p009_b006_3_md, max_size: 8.81pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.175422770182308pt) }]
#context {
  place(top + left, dx: 296.3068201700847pt, dy: 291.42792378743485pt, rp3_item_p009_b006_3_body)
}
#let rp3_item_p009_b007_4_md = "职务：..."
#let rp3_item_p009_b007_4_body = block(width: 67.15583089192705pt, height: 13.563676757812459pt)[#{ pdftr_fit_markdown(rp3_item_p009_b007_4_md, max_size: 13.03pt, min_size: 10.83pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.563676757812459pt) }]
#context {
  place(top + left, dx: 295.957607014974pt, dy: 312.3633235677083pt, rp3_item_p009_b007_4_body)
}
#let rp3_item_p009_b008_5_md = "达累斯萨拉姆"
#let rp3_item_p009_b008_5_body = block(width: 91.28367004394532pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p009_b008_5_md, max_size: 8.4pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 121.77152557373047pt, dy: 354.0601440429688pt, rp3_item_p009_b008_5_body)
}
#let rp3_item_p009_b010_6_md = "日期:\\*.."
#let rp3_item_p009_b010_6_body = block(width: 41.821593983968086pt, height: 9.574375813802135pt)[#{ pdftr_fit_markdown(rp3_item_p009_b010_6_md, max_size: 9.2pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.574375813802135pt) }]
#context {
  place(top + left, dx: 85.33636233011882pt, dy: 360.6170479329427pt, rp3_item_p009_b010_6_body)
}
#let rp3_item_p009_b011_7_md = "日期："
#let rp3_item_p009_b011_7_body = block(width: 26.540624999999977pt, height: 12.36687500000005pt)[#{ pdftr_fit_markdown(rp3_item_p009_b011_7_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 12.36687500000005pt) }]
#context {
  place(top + left, dx: 294.8887858072917pt, dy: 360.2817724609375pt, rp3_item_p009_b011_7_body)
}
#let rp3_item_p009_b012_8_md = "代表 EMERGENCY PLUS MEDICAL SERVICES TANZANIA LIMITED 签署"
#let rp3_item_p009_b012_8_body = block(width: 402.9349466959635pt, height: 21.941250813802014pt)[#{ pdftr_fit_markdown(rp3_item_p009_b012_8_md, max_size: 11.72pt, min_size: 10.92pt, max_leading: 0.72em, min_leading: 0.64em, fit_height: 21.941250813802014pt) }]
#context {
  place(top + left, dx: 108.80810038248697pt, dy: 432.3101159667969pt, rp3_item_p009_b012_8_body)
}
#let rp3_item_p009_b013_9_md = "见证人："
#let rp3_item_p009_b013_9_body = block(width: 52.679115804036485pt, height: 11.96794108072919pt)[#{ pdftr_fit_markdown(rp3_item_p009_b013_9_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072919pt) }]
#context {
  place(top + left, dx: 295.99993998209635pt, dy: 493.10473388671875pt, rp3_item_p009_b013_9_body)
}
#let rp3_item_p009_b016_10_md = "签署人"
#let rp3_item_p009_b016_10_body = block(width: 14.074571228027338pt, height: 8.776507975260415pt)[#{ pdftr_fit_markdown(rp3_item_p009_b016_10_md, max_size: 8.43pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.776507975260415pt) }]
#context {
  place(top + left, dx: 86.72265803019206pt, dy: 532.8960274251302pt, rp3_item_p009_b016_10_body)
}
#let rp3_item_p009_b017_11_md = "董事总经理"
#let rp3_item_p009_b017_11_body = block(width: 75.19843750000001pt, height: 11.967941080729133pt)[#{ pdftr_fit_markdown(rp3_item_p009_b017_11_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967941080729133pt) }]
#context {
  place(top + left, dx: 146.74595540364584pt, dy: 547.8517228190104pt, rp3_item_p009_b017_11_body)
}
#let rp3_item_p009_b018_12_md = "财务与行政主任"
#let rp3_item_p009_b018_12_body = block(width: 152.0053731282552pt, height: 11.56900716145833pt)[#{ pdftr_fit_markdown(rp3_item_p009_b018_12_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.56900716145833pt) }]
#context {
  place(top + left, dx: 363.80128885904946pt, dy: 547.4145930989583pt, rp3_item_p009_b018_12_body)
}
#let rp3_item_p009_b019_13_md = "职务：.."
#let rp3_item_p009_b019_13_body = block(width: 66.35155766805013pt, height: 11.96794108072902pt)[#{ pdftr_fit_markdown(rp3_item_p009_b019_13_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072902pt) }]
#context {
  place(top + left, dx: 86.40518684387206pt, dy: 554.6420467122397pt, rp3_item_p009_b019_13_body)
}
#let rp3_item_p009_b020_14_md = "职位："
#let rp3_item_p009_b020_14_body = block(width: 58.308955891927155pt, height: 11.96794108072902pt)[#{ pdftr_fit_markdown(rp3_item_p009_b020_14_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072902pt) }]
#context {
  place(top + left, dx: 295.3014953613281pt, dy: 555.4908422851563pt, rp3_item_p009_b020_14_body)
}
#let rp3_item_p009_b023_15_md = "签名"
#let rp3_item_p009_b023_15_body = block(width: 21.312938435872468pt, height: 10.372205403645694pt)[#{ pdftr_fit_markdown(rp3_item_p009_b023_15_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.372205403645694pt) }]
#context {
  place(top + left, dx: 295.59779307047523pt, dy: 579.6304256184897pt, rp3_item_p009_b023_15_body)
}
#let rp3_item_p009_b025_16_md = "日期：.30th.March.2026"
#let rp3_item_p009_b025_16_body = block(width: 99.72841567993163pt, height: 9.175403645833399pt)[#{ pdftr_fit_markdown(rp3_item_p009_b025_16_md, max_size: 8.81pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.175403645833399pt) }]
#context {
  place(top + left, dx: 86.86022605895997pt, dy: 601.6607926432291pt, rp3_item_p009_b025_16_body)
}
#let rp3_item_p009_b026_17_md = "日期:....."
#let rp3_item_p009_b026_17_body = block(width: 42.22372334798172pt, height: 11.56904541015615pt)[#{ pdftr_fit_markdown(rp3_item_p009_b026_17_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.56904541015615pt) }]
#context {
  place(top + left, dx: 295.30149892171227pt, dy: 603.0103381347657pt, rp3_item_p009_b026_17_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 10, width: 596.0pt))
#let rp4_item_p010_b000_0_md = "1. 总体工作范围"
#let rp4_item_p010_b000_0_body = block(width: 130.89pt, height: 13.4pt)[#{ pdftr_fit_single_line_markdown(rp4_item_p010_b000_0_md, max_size: 12.26pt, min_size: 10.06pt, fit_width: 130.89pt, fit_height: 13.4pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.99361317952474pt, dy: 212.81378580729165pt, rp4_item_p010_b000_0_body)
}
#let rp4_item_p010_b001_1_md = "适用于患者转运的救护车适当配置于达累斯萨拉姆市内。"
#let rp4_item_p010_b001_1_body = block(width: 342.2132242838542pt, height: 23.93588216145838pt)[#{ pdftr_fit_markdown(rp4_item_p010_b001_1_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 23.93588216145838pt) }]
#context {
  place(top + left, dx: 171.55106201171873pt, dy: 238.42520670572912pt, rp4_item_p010_b001_1_body)
}
#let rp4_item_p010_b002_2_md = "每辆车配备足够数量的工作人员，并经过妥善培训，能够处理转运过程中的病人。"
#let rp4_item_p010_b002_2_body = block(width: 341.81109008789053pt, height: 24.33481608072907pt)[#{ pdftr_fit_markdown(rp4_item_p010_b002_2_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.33481608072907pt) }]
#context {
  place(top + left, dx: 171.54047953287758pt, dy: 274.9359244791667pt, rp4_item_p010_b002_2_body)
}
#let rp4_item_p010_b003_3_md = "了解感染控制及正确使用个人防护装备，可降低转运患者及工作人员的风险。"
#let rp4_item_p010_b003_3_body = block(width: 342.61534881591797pt, height: 24.334816080729183pt)[#{ pdftr_fit_markdown(rp4_item_p010_b003_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729183pt) }]
#context {
  place(top + left, dx: 171.13835525512695pt, dy: 312.7070833333333pt, rp4_item_p010_b003_3_body)
}
#let rp4_item_p010_b004_4_md = "在转运患者期间，针对心脏骤停时提供救生服务所需的最低培训要求（ACLS/BLS）。"
#let rp4_item_p010_b004_4_body = block(width: 341.0068216959635pt, height: 24.733749999999986pt)[#{ pdftr_fit_markdown(rp4_item_p010_b004_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.733749999999986pt) }]
#context {
  place(top + left, dx: 172.36591288248698pt, dy: 350.9153922526042pt, rp4_item_p010_b004_4_body)
}
#let rp4_item_p010_b005_5_md = "需提供患者转运期间所需储备的物品。"
#let rp4_item_p010_b005_5_body = block(width: 341.4089558919271pt, height: 23.13801432291666pt)[#{ pdftr_fit_markdown(rp4_item_p010_b005_5_md, max_size: 11.72pt, min_size: 10.92pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.13801432291666pt) }]
#context {
  place(top + left, dx: 172.37649536132812pt, dy: 387.78682779947917pt, rp4_item_p010_b005_5_body)
}
#let rp4_item_p010_b006_6_md = "设备："
#let rp4_item_p010_b006_6_body = block(width: 67.96008961995443pt, height: 13.164742838541656pt)[#{ pdftr_fit_markdown(rp4_item_p010_b006_6_md, max_size: 12.65pt, min_size: 10.45pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.164742838541656pt) }]
#context {
  place(top + left, dx: 116.92478612263997pt, dy: 425.6640885416667pt, rp4_item_p010_b006_6_body)
}
#let rp4_item_p010_b007_7_md = "不同规格的基础和高级气道控制设备，包括但不限于口咽通气道、鼻咽通气道、气管插管（ETT）和喉罩（LMA）、喉镜手柄及喉镜片，以及其他插管装置。"
#let rp4_item_p010_b007_7_body = block(width: 372.7751525878906pt, height: 15.710757161458318pt)[#{ pdftr_fit_markdown(rp4_item_p010_b007_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 15.710757161458318pt) }]
#context {
  place(top + left, dx: 139.7615732828776pt, dy: 451.44188313802084pt, rp4_item_p010_b007_7_body)
}
#let rp4_item_p010_b008_8_md = "供氧装置，包括尺寸合适的鼻塞、面罩、非再呼吸面罩"
#let rp4_item_p010_b008_8_body = block(width: 371.56875pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b008_8_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 140.153125pt, dy: 539.4944020507813pt, rp4_item_p010_b008_8_body)
}
#let rp4_item_p010_b009_9_md = "吸引设备和导管（柔性/刚性）"
#let rp4_item_p010_b009_9_body = block(width: 193.42486673990888pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b009_9_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 135.041828918457pt, dy: 509.90265836588543pt, rp4_item_p010_b009_9_body)
}
#let rp4_item_p010_b010_10_md = "不同尺寸的带储气囊的BVM装置"
#let rp4_item_p010_b010_10_body = block(width: 221.57400919596353pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b010_10_md, max_size: 13.41pt, min_size: 11.21pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 135.7825958251953pt, dy: 583.6631130208333pt, rp4_item_p010_b010_10_body)
}
#let rp4_item_p010_b011_11_md = "各种尺寸的静脉套管、穿刺针、骨内（IO）穿刺针"
#let rp4_item_p010_b011_11_body = block(width: 301.5980183919271pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b011_11_md, max_size: 11.4pt, min_size: 10.6pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 138.73508911132814pt, dy: 644.9297380859376pt, rp4_item_p010_b011_11_body)
}
#let rp4_item_p010_b012_12_md = "配备儿童探头的脉搏血氧仪"
#let rp4_item_p010_b012_12_body = block(width: 158.4395009358724pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b012_12_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 134.12116139729818pt, dy: 615.6435583658855pt, rp4_item_p010_b012_12_body)
}
#let rp4_item_p010_b013_13_md = "药物（肾上腺素、阿托品、10%葡萄糖、葡萄糖酸钙、抗惊厥药）和液体"
#let rp4_item_p010_b013_13_body = block(width: 372.37300872802734pt, height: 17.13805257161448pt)[#{ pdftr_fit_markdown(rp4_item_p010_b013_13_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.74em, min_leading: 0.66em, fit_height: 17.13805257161448pt) }]
#context {
  place(top + left, dx: 139.32770156860352pt, dy: 677.493080777995pt, rp4_item_p010_b013_13_body)
}
#let rp4_item_p010_b014_14_md = "手动除颤器或具有儿科功能的AED（电极片和导线）"
#let rp4_item_p010_b014_14_body = block(width: 311.6512959798177pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b014_14_md, max_size: 11.56pt, min_size: 10.76pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 138.15305074055988pt, dy: 702.6639914225262pt, rp4_item_p010_b014_14_body)
}
#let rp4_item_p010_b015_15_md = "转运暖箱（用于新生儿）"
#let rp4_item_p010_b015_15_body = block(width: 147.58195495605466pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b015_15_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 134.68203481038412pt, dy: 770.2525029459636pt, rp4_item_p010_b015_15_body)
}
#let rp4_item_p010_b016_16_md = "转运呼吸机，配备儿科管路和设置"
#let rp4_item_p010_b016_16_body = block(width: 239.66988372802734pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b016_16_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 135.83551406860352pt, dy: 736.0392557454429pt, rp4_item_p010_b016_16_body)
}
#let rp4_item_p010_b017_17_md = "软颈托/适当尺寸的颈椎和骨折固定装置/设备"
#let rp4_item_p010_b017_17_body = block(width: 371.1666158040365pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b017_17_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 139.719243367513pt, dy: 794.5553548502605pt, rp4_item_p010_b017_17_body)
}
#let rp4_item_p010_b018_18_md = "儿科和新生儿血压袖带"
#let rp4_item_p010_b018_18_body = block(width: 137.5286966959636pt, height: 11.170073242187527pt)[#{ pdftr_fit_markdown(rp4_item_p010_b018_18_md, max_size: 10.73pt, min_size: 8.53pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.170073242187527pt) }]
#context {
  place(top + left, dx: 131.45440165201822pt, dy: 869.0830217773441pt, rp4_item_p010_b018_18_body)
}
#let rp4_item_p010_b019_19_md = "儿科听诊器"
#let rp4_item_p010_b019_19_body = block(width: 93.6964365641276pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp4_item_p010_b019_19_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 131.14751942952475pt, dy: 839.8605017252605pt, rp4_item_p010_b019_19_body)
}
#let rp4_item_p010_b020_20_md = "附件1"
#let rp4_item_p010_b020_20_body = block(width: 71.36pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp4_item_p010_b020_20_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 71.36pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 276.08387451171876pt, dy: 162.3471052042643pt, rp4_item_p010_b020_20_body)
}
#let rp4_item_p010_b021_21_md = "工作范围"
#let rp4_item_p010_b021_21_body = block(width: 96.27pt, height: 10.89pt)[#{ pdftr_fit_single_line_markdown(rp4_item_p010_b021_21_md, max_size: 9.96pt, min_size: 7.76pt, fit_width: 96.27pt, fit_height: 10.89pt, weight: "bold") }]
#context {
  place(top + left, dx: 264.43268127441405pt, dy: 188.66688313802086pt, rp4_item_p010_b021_21_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 11, width: 596.0pt))
#let rp5_item_p011_b000_0_md = "附件2"
#let rp5_item_p011_b000_0_body = block(width: 71.78pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp5_item_p011_b000_0_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 71.78pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 276.94105529785156pt, dy: 177.20093648274744pt, rp5_item_p011_b000_0_body)
}
#let rp5_item_p011_b001_1_md = "救护车设备清单"
#let rp5_item_p011_b001_1_body = block(width: 191.7pt, height: 10.89pt)[#{ pdftr_fit_single_line_markdown(rp5_item_p011_b001_1_md, max_size: 9.96pt, min_size: 7.76pt, fit_width: 191.7pt, fit_height: 10.89pt, weight: "bold") }]
#context {
  place(top + left, dx: 219.4152028401693pt, dy: 203.0963067626953pt, rp5_item_p011_b001_1_body)
}
#let rp5_item_p011_b002_2_md = "E-Plus应为其客户的患者提供救护车和紧急医疗运输服务以及撤离服务，包括以下设备："
#let rp5_item_p011_b002_2_body = block(width: 404.14134928385425pt, height: 23.53694824218752pt)[#{ pdftr_fit_markdown(rp5_item_p011_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.53694824218752pt) }]
#context {
  place(top + left, dx: 108.41654866536459pt, dy: 229.50018229166662pt, rp5_item_p011_b002_2_body)
}
#let rp5_item_p011_b003_3_md = "1. 自动体外除颤器"
#let rp5_item_p011_b003_3_body = block(width: 163.26506296793622pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b003_3_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.85611089070638pt, dy: 266.05332194010424pt, rp5_item_p011_b003_3_body)
}
#let rp5_item_p011_b004_4_md = "2.脉搏血氧仪"
#let rp5_item_p011_b004_4_body = block(width: 85.25169576009112pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b004_4_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 116.95653940836588pt, dy: 293.62017415364573pt, rp5_item_p011_b004_4_body)
}
#let rp5_item_p011_b005_5_md = "机械通气机"
#let rp5_item_p011_b005_5_body = block(width: 114.60725046793621pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b005_5_md, max_size: 13.41pt, min_size: 11.21pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.57564214070638pt, dy: 321.250686035156pt, rp5_item_p011_b005_5_body)
}
#let rp5_item_p011_b006_6_md = "便携式呼吸机"
#let rp5_item_p011_b006_6_body = block(width: 98.52202758789062pt, height: 10.372205403645921pt)[#{ pdftr_fit_markdown(rp5_item_p011_b006_6_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.372205403645921pt) }]
#context {
  place(top + left, dx: 118.57563578287761pt, dy: 353.15473977864553pt, rp5_item_p011_b006_6_body)
}
#let rp5_item_p011_b008_7_md = "气道管理套件"
#let rp5_item_p011_b008_7_body = block(width: 122.64986673990886pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b008_7_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.63387807210286pt, dy: 379.4799717122393pt, rp5_item_p011_b008_7_body)
}
#let rp5_item_p011_b009_8_md = "血糖仪"
#let rp5_item_p011_b009_8_body = block(width: 67.9600799560547pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b009_8_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.19467315673828pt, dy: 404.32832636718723pt, rp5_item_p011_b009_8_body)
}
#let rp5_item_p011_b010_9_md = "电动吸引器"
#let rp5_item_p011_b010_9_body = block(width: 130.6924830118815pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b010_9_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.57563858032228pt, dy: 431.85698277994766pt, rp5_item_p011_b010_9_body)
}
#let rp5_item_p011_b011_10_md = "9.牵引夹板"
#let rp5_item_p011_b011_10_body = block(width: 87.26234741210936pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b011_10_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 117.00945129394532pt, dy: 444.20263300781227pt, rp5_item_p011_b011_10_body)
}
#let rp5_item_p011_b012_11_md = "脊柱板"
#let rp5_item_p011_b012_11_body = block(width: 70.37287546793621pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b012_11_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 117.41157964070638pt, dy: 471.76948644205703pt, rp5_item_p011_b012_11_body)
}
#let rp5_item_p011_b013_12_md = "11.铲式担架"
#let rp5_item_p011_b013_12_body = block(width: 83.24104410807293pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b013_12_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.59680379231771pt, dy: 485.7363362141924pt, rp5_item_p011_b013_12_body)
}
#let rp5_item_p011_b014_13_md = "12.氧气瓶及适当面罩"
#let rp5_item_p011_b014_13_body = block(width: 186.18650919596354pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b014_13_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 120.88259582519532pt, dy: 510.58473033854136pt, rp5_item_p011_b014_13_body)
}
#let rp5_item_p011_b015_14_md = "13.一副带一组绑带的担架"
#let rp5_item_p011_b015_14_body = block(width: 146.77769622802737pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b015_14_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.42223281860352pt, dy: 538.1643144856769pt, rp5_item_p011_b015_14_body)
}
#let rp5_item_p011_b016_15_md = "14.基本敷料包"
#let rp5_item_p011_b016_15_body = block(width: 102.94545542399091pt, height: 11.967941080729133pt)[#{ pdftr_fit_markdown(rp5_item_p011_b016_15_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967941080729133pt) }]
#context {
  place(top + left, dx: 118.26875279744466pt, dy: 566.6330325520831pt, rp5_item_p011_b016_15_body)
}
#let rp5_item_p011_b017_16_md = "16. 袋阀面罩 (BVM)"
#let rp5_item_p011_b017_16_body = block(width: 127.87756296793619pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b017_16_md, max_size: 10.73pt, min_size: 8.53pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 118.50156173706056pt, dy: 590.7980797526039pt, rp5_item_p011_b017_16_body)
}
#let rp5_item_p011_b019_17_md = "17. 上肢和下肢夹板"
#let rp5_item_p011_b019_17_body = block(width: 160.45014292399088pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp5_item_p011_b019_17_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 119.78203404744465pt, dy: 603.5426638997395pt, rp5_item_p011_b019_17_body)
}
#let rp5_item_p011_b020_18_md = "18.颈托"
#let rp5_item_p011_b020_18_body = block(width: 84.84957122802734pt, height: 10.372205403645921pt)[#{ pdftr_fit_markdown(rp5_item_p011_b020_18_md, max_size: 9.96pt, min_size: 7.76pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.372205403645921pt) }]
#context {
  place(top + left, dx: 117.79254531860352pt, dy: 630.1438225260415pt, rp5_item_p011_b020_18_body)
}
#let rp5_item_p011_b022_19_md = "20.插管包"
#let rp5_item_p011_b022_19_body = block(width: 75.60057169596354pt, height: 10.771177571614544pt)[#{ pdftr_fit_markdown(rp5_item_p011_b022_19_md, max_size: 10.35pt, min_size: 8.15pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.771177571614544pt) }]
#context {
  place(top + left, dx: 117.97243957519532pt, dy: 655.1958623209634pt, rp5_item_p011_b022_19_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 12, width: 596.0pt))
#let rp6_item_p012_b000_0_md = "附录3"
#let rp6_item_p012_b000_0_body = block(width: 72.2pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp6_item_p012_b000_0_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 72.2pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 275.25846099853516pt, dy: 178.89852701822915pt, rp6_item_p012_b000_0_body)
}
#let rp6_item_p012_b001_1_md = "服务付款费率"
#let rp6_item_p012_b001_1_body = block(width: 198.45pt, height: 12.15pt)[#{ pdftr_fit_single_line_markdown(rp6_item_p012_b001_1_md, max_size: 11.11pt, min_size: 8.91pt, fit_width: 198.45pt, fit_height: 12.15pt, weight: "bold") }]
#context {
  place(top + left, dx: 214.08167215983073pt, dy: 203.07450256347656pt, rp6_item_p012_b001_1_body)
}
#let rp6_item_p012_b003_2_md = "描述"
#let rp6_item_p012_b003_2_body = block(width: 55.89616038004557pt, height: 12.366874999999993pt)[#{ pdftr_fit_markdown(rp6_item_p012_b003_2_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 12.366874999999993pt) }]
#context {
  place(top + left, dx: 61.15561345418294pt, dy: 229.9924658203125pt, rp6_item_p012_b003_2_body)
}
#let rp6_item_p012_b004_3_md = "费用"
#let rp6_item_p012_b004_3_body = block(width: 25.334222412109398pt, height: 11.569026285807297pt)[#{ pdftr_fit_markdown(rp6_item_p012_b004_3_md, max_size: 11.11pt, min_size: 8.91pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.569026285807297pt) }]
#context {
  place(top + left, dx: 393.90818583170574pt, dy: 229.54260477701823pt, rp6_item_p012_b004_3_body)
}
#let rp6_item_p012_b005_4_md = "1. 距我们在Dar Es Salaam的救护站30KMS内的稳定患者的地面救护车服务"
#let rp6_item_p012_b005_4_body = block(width: 278.67658182779945pt, height: 24.33481608072924pt)[#{ pdftr_fit_markdown(rp6_item_p012_b005_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.33481608072924pt) }]
#context {
  place(top + left, dx: 84.37336883544923pt, dy: 257.9601147460937pt, rp6_item_p012_b005_4_body)
}
#let rp6_item_p012_b007_5_md = "2. 地面救护车服务（插管患者）在达累斯萨拉姆我方救护站30公里范围内"
#let rp6_item_p012_b007_5_body = block(width: 292.7511240641277pt, height: 22.340165608723964pt)[#{ pdftr_fit_markdown(rp6_item_p012_b007_5_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.72em, min_leading: 0.64em, fit_height: 22.340165608723964pt) }]
#context {
  place(top + left, dx: 84.32045237223306pt, dy: 292.27245259602864pt, rp6_item_p012_b007_5_body)
}
#let rp6_item_p012_b009_6_md = "3. 往返Julius Nyerere International Airport的转运（病情稳定患者）"
#let rp6_item_p012_b009_6_body = block(width: 284.7085126241048pt, height: 23.138014322916717pt)[#{ pdftr_fit_markdown(rp6_item_p012_b009_6_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.138014322916717pt) }]
#context {
  place(top + left, dx: 83.68551063537598pt, dy: 317.761640625pt, rp6_item_p012_b009_6_body)
}
#let rp6_item_p012_b011_7_md = "4.待时费（每小时）"
#let rp6_item_p012_b011_7_body = block(width: 127.47542877197266pt, height: 13.962610677083376pt)[#{ pdftr_fit_markdown(rp6_item_p012_b011_7_md, max_size: 13.41pt, min_size: 11.21pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.962610677083376pt) }]
#context {
  place(top + left, dx: 79.12450383504232pt, dy: 354.8155696614583pt, rp6_item_p012_b011_7_body)
}
#let rp6_item_p012_b013_8_md = "5. 每公里附加费"
#let rp6_item_p012_b013_8_body = block(width: 137.52869669596353pt, height: 11.96794108072919pt)[#{ pdftr_fit_markdown(rp6_item_p012_b013_8_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.96794108072919pt) }]
#context {
  place(top + left, dx: 80.23565165201822pt, dy: 379.79121663411456pt, rp6_item_p012_b013_8_body)
}
#let rp6_item_p012_b015_9_md = "6. 待命救护车服务——适用于距我司所在地30公里范围内的活动（体育赛事、会议、社交活动）"
#let rp6_item_p012_b015_9_body = block(width: 282.6978802998861pt, height: 24.733749999999986pt)[#{ pdftr_fit_markdown(rp6_item_p012_b015_9_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.733749999999986pt) }]
#context {
  place(top + left, dx: 83.63259925842284pt, dy: 403.9647900390625pt, rp6_item_p012_b015_9_body)
}
#let rp6_item_p012_b016_10_md = "每辆救护车 TZS 400,000"
#let rp6_item_p012_b016_10_body = block(width: 66.75369669596347pt, height: 23.536948242187464pt)[#{ pdftr_fit_markdown(rp6_item_p012_b016_10_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.57em, min_leading: 0.37em, fit_height: 23.536948242187464pt) }]
#context {
  place(top + left, dx: 394.1515736897787pt, dy: 404.77538981119795pt, rp6_item_p012_b016_10_body)
}
#let rp6_item_p012_b017_11_md = "7. 在距我方所在地30KMS范围内参与演练活动。"
#let rp6_item_p012_b017_11_body = block(width: 285.11065165201825pt, height: 11.56900716145833pt)[#{ pdftr_fit_markdown(rp6_item_p012_b017_11_md, max_size: 11.1pt, min_size: 10.3pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 11.56900716145833pt) }]
#context {
  place(top + left, dx: 84.54268646240234pt, dy: 437.49625813802083pt, rp6_item_p012_b017_11_body)
}
#let rp6_item_p012_b018_12_md = "每辆救护车 TZS 400,000"
#let rp6_item_p012_b018_12_body = block(width: 66.3515625pt, height: 23.93588216145838pt)[#{ pdftr_fit_markdown(rp6_item_p012_b018_12_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.59em, min_leading: 0.39em, fit_height: 23.93588216145838pt) }]
#context {
  place(top + left, dx: 394.5642903645833pt, dy: 437.8909456380208pt, rp6_item_p012_b018_12_body)
}
