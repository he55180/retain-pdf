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
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 2, width: 595.3200073242188pt))
#let rp0_item_p002_b002_0_md = "达累斯萨拉姆海运门户项目(DMGP)"
#let rp0_item_p002_b002_0_body = block(width: 281.44pt, height: 10.44pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p002_b002_0_md, max_size: 9.56pt, min_size: 7.36pt, fit_width: 281.44pt, fit_height: 10.44pt, weight: "bold") }]
#context {
  place(top + left, dx: 168.8136135974061pt, dy: 88.91710198324577pt, rp0_item_p002_b002_0_body)
}
#let rp0_item_p002_b004_1_md = "达累斯萨拉姆港滚装船码头及1-7号泊位混凝土损伤修复"
#let rp0_item_p002_b004_1_body = block(width: 454.82pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p002_b004_1_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 454.82pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 86.15890020458652pt, dy: 115.05810874192267pt, rp0_item_p002_b004_1_body)
}
#let rp0_item_p002_b006_2_md = "项"
#let rp0_item_p002_b006_2_body = block(width: 33.26807203516364pt, height: 18.710988760814075pt)[#{ pdftr_fit_markdown(rp0_item_p002_b006_2_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.38em, min_leading: 0.18em, fit_height: 18.710988760814075pt) }]
#context {
  place(top + left, dx: 58.22120491601527pt, dy: 147.49140690412372pt, rp0_item_p002_b006_2_body)
}
#let rp0_item_p002_b007_3_md = "描述"
#let rp0_item_p002_b007_3_body = block(width: 66.39292773753402pt, height: 16.341075637806227pt)[#{ pdftr_fit_markdown(rp0_item_p002_b007_3_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 16.341075637806227pt) }]
#context {
  place(top + left, dx: 243.254228322953pt, dy: 148.59705555417574pt, rp0_item_p002_b007_3_body)
}
#let rp0_item_p002_b008_4_md = "行动项"
#let rp0_item_p002_b008_4_body = block(width: 37.08951240181926pt, height: 14.153632659688583pt)[#{ pdftr_fit_markdown(rp0_item_p002_b008_4_md, max_size: 13.6pt, min_size: 11.4pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.153632659688583pt) }]
#context {
  place(top + left, dx: 480.69458952844144pt, dy: 149.34595734987408pt, rp0_item_p002_b008_4_body)
}
#let rp0_item_p002_b010_5_md = "承包商开工准备情况"
#let rp0_item_p002_b010_5_body = block(width: 204.20449732989073pt, height: 14.883621167391539pt)[#{ pdftr_fit_markdown(rp0_item_p002_b010_5_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.883621167391539pt) }]
#context {
  place(top + left, dx: 116.61321793869138pt, dy: 166.8056062143296pt, rp0_item_p002_b010_5_body)
}
#let rp0_item_p002_b011_6_md = "关于现场可达性，驻地工程师在会上通报，正如2026年5月12日三方会议所报告的，目前在港区内获取工作空间仍然困难。尽管如此，业主承诺将持续与迪拜世界港口公司（DP World）跟进，一旦时机合适即为承包商分配空间。随后，各方同意由坦桑尼亚港口管理局（TPA）与迪拜世界港口公司协调，提前为承包商工人办好港区通行证，以便在情况允许开工时顺利进入。"
#let rp0_item_p002_b011_6_body = block(width: 323.84684201329947pt, height: 65.88217357888817pt)[#{ pdftr_fit_markdown(rp0_item_p002_b011_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 65.88217357888817pt) }]
#context {
  place(top + left, dx: 113.11003810539842pt, dy: 186.3722868695855pt, rp0_item_p002_b011_6_body)
}
#let rp0_item_p002_b012_7_md = "关于铺砌块，承包商被要求提供代表样品以及来自拟用于现场施工的实际生产的验证试验结果。承包商在会上告知，他无法找到一家信誉良好的"
#let rp0_item_p002_b012_7_body = block(width: 319.47870164960625pt, height: 78.90038146156074pt)[#{ pdftr_fit_markdown(rp0_item_p002_b012_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 78.90038146156074pt) }]
#context {
  place(top + left, dx: 116.7330998338759pt, dy: 328.2479601460397pt, rp0_item_p002_b012_7_body)
}
#let rp0_item_p002_b013_8_md = "国内能够进行抗滑阻力试验的实验室，因此已请求驻地工程师协助在坦桑尼亚寻找一家实验室进行上述试验。"
#let rp0_item_p002_b013_8_body = block(width: 322.89083288908pt, height: 45.58306749820713pt)[#{ pdftr_fit_markdown(rp0_item_p002_b013_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 45.58306749820713pt) }]
#context {
  place(top + left, dx: 114.83075625300407pt, dy: 452.962409127593pt, rp0_item_p002_b013_8_body)
}
#let rp0_item_p002_b014_9_md = "驻地工程师已承诺调查此事并将相应提出建议。同时，工程师正在分析承包商提交的劈裂抗拉试验结果，并将很快给出答复。"
#let rp0_item_p002_b014_9_body = block(width: 325.6106064513326pt, height: 47.809647092819205pt)[#{ pdftr_fit_markdown(rp0_item_p002_b014_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 47.809647092819205pt) }]
#context {
  place(top + left, dx: 114.13091826960445pt, dy: 504.11042820894716pt, rp0_item_p002_b014_9_body)
}
#let rp0_item_p002_b020_10_md = "合同事项"
#let rp0_item_p002_b020_10_body = block(width: 97.52413131892682pt, height: 14.628606791496281pt)[#{ pdftr_fit_markdown(rp0_item_p002_b020_10_md, max_size: 14.05pt, min_size: 11.85pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.628606791496281pt) }]
#context {
  place(top + left, dx: 108.33830298930407pt, dy: 560.9102595170735pt, rp0_item_p002_b020_10_body)
}
#let rp0_item_p002_b022_11_md = "劳工、材料与设备"
#let rp0_item_p002_b022_11_body = block(width: 196.3035373315215pt, height: 14.730808134078984pt)[#{ pdftr_fit_markdown(rp0_item_p002_b022_11_md, max_size: 14.15pt, min_size: 11.95pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.730808134078984pt) }]
#context {
  place(top + left, dx: 110.44966930523515pt, dy: 579.8997451087236pt, rp0_item_p002_b022_11_body)
}
#let rp0_item_p002_b023_12_md = "驻地工程师再次提醒承包商，要求其根据合同中批准的员工名单提交所有员工（包括本地和外国员工）的名册。"
#let rp0_item_p002_b023_12_body = block(width: 321.9701423928142pt, height: 36.89545999288555pt)[#{ pdftr_fit_markdown(rp0_item_p002_b023_12_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 36.89545999288555pt) }]
#context {
  place(top + left, dx: 114.88747379258275pt, dy: 599.5199996908904pt, rp0_item_p002_b023_12_body)
}
#let rp0_item_p002_b024_13_md = "关于外国员工，驻地工程师再次提醒承包商提交护照入境许可副本，以证明其获准入境并在该国工作。承包商承诺在2026年5月21日的下次会议前提交。"
#let rp0_item_p002_b024_13_body = block(width: 322.38400354236364pt, height: 29.377478638172178pt)[#{ pdftr_fit_markdown(rp0_item_p002_b024_13_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 29.377478638172178pt) }]
#context {
  place(top + left, dx: 114.70213875547051pt, dy: 641.6221689423322pt, rp0_item_p002_b024_13_body)
}
#let rp0_item_p002_b025_14_md = "关于已调运的设备，驻地工程师询问有缺陷的压缩机是否已修复。承包商告知会议，他仍在等待从中国订购的备件，预计于2026年5月底前抵达。"
#let rp0_item_p002_b025_14_body = block(width: 324.9979056477547pt, height: 40.9006447725295pt)[#{ pdftr_fit_markdown(rp0_item_p002_b025_14_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 40.9006447725295pt) }]
#context {
  place(top + left, dx: 113.44887290596962pt, dy: 715.7409493914843pt, rp0_item_p002_b025_14_body)
}
#let rp0_item_p002_b026_15_md = "关于混凝土配合比设计，承包商已提交了28天强度结果，工程师正在核查并将给予相应回复。"
#let rp0_item_p002_b026_15_body = block(width: 321.05247719734905pt, height: 27.050792322158713pt)[#{ pdftr_fit_markdown(rp0_item_p002_b026_15_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 27.050792322158713pt) }]
#context {
  place(top + left, dx: 114.78263027146458pt, dy: 800.6514485393762pt, rp0_item_p002_b026_15_body)
}
#let rp0_item_p002_b032_16_md = "PM设施"
#let rp0_item_p002_b032_16_body = block(width: 66.58909386992455pt, height: 15.064830315113113pt)[#{ pdftr_fit_markdown(rp0_item_p002_b032_16_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.064830315113113pt) }]
#context {
  place(top + left, dx: 105.81667959392071pt, dy: 830.8211581491231pt, rp0_item_p002_b032_16_body)
}
#let rp0_item_p002_b033_17_md = "驻地工程师向会议报告，TPA未提供任何最新进展。"
#let rp0_item_p002_b033_17_body = block(width: 307.6704038485884pt, height: 8.822366440296264pt)[#{ pdftr_fit_markdown(rp0_item_p002_b033_17_md, max_size: 11.74pt, min_size: 10.94pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 8.822366440296264pt) }]
#context {
  place(top + left, dx: 112.18370507135987pt, dy: 851.0383757971524pt, rp0_item_p002_b033_17_body)
}
#let rp0_item_p002_b036_18_md = "日报、周报及月报"
#let rp0_item_p002_b036_18_body = block(width: 175.87339256480334pt, height: 14.871282117366718pt)[#{ pdftr_fit_markdown(rp0_item_p002_b036_18_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.871282117366718pt) }]
#context {
  place(top + left, dx: 109.39592574648559pt, dy: 869.7959828137159pt, rp0_item_p002_b036_18_body)
}
#let rp0_item_p002_b037_19_md = "驻地工程师告知会议，承包商已按合同要求提交相应报告。周报应按周提交，周期为周一至周日。"
#let rp0_item_p002_b037_19_body = block(width: 321.14613488167527pt, height: 52.39792350530615pt)[#{ pdftr_fit_markdown(rp0_item_p002_b037_19_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 52.39792350530615pt) }]
#context {
  place(top + left, dx: 115.00561234429479pt, dy: 889.9112375639677pt, rp0_item_p002_b037_19_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 3, width: 595.3200073242188pt))
#let rp1_item_p003_b002_0_md = "达累斯萨拉姆海运门户项目(DMGP)"
#let rp1_item_p003_b002_0_body = block(width: 281.44pt, height: 10.44pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p003_b002_0_md, max_size: 9.56pt, min_size: 7.36pt, fit_width: 281.44pt, fit_height: 10.44pt, weight: "bold") }]
#context {
  place(top + left, dx: 168.8136135974061pt, dy: 88.91710198324577pt, rp1_item_p003_b002_0_body)
}
#let rp1_item_p003_b004_1_md = "达累斯萨拉姆港滚装船码头及1-7号泊位混凝土损伤修复"
#let rp1_item_p003_b004_1_body = block(width: 454.82pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p003_b004_1_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 454.82pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 86.15890020458652pt, dy: 115.05810874192267pt, rp1_item_p003_b004_1_body)
}
#let rp1_item_p003_b009_2_md = "新缺陷"
#let rp1_item_p003_b009_2_body = block(width: 68.05911215357482pt, height: 15.437361730635189pt)[#{ pdftr_fit_markdown(rp1_item_p003_b009_2_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.437361730635189pt) }]
#context {
  place(top + left, dx: 106.25188605505973pt, dy: 166.98038857504724pt, rp1_item_p003_b009_2_body)
}
#let rp1_item_p003_b010_3_md = "关于新缺陷，驻地工程师在会上通报，业主尚未就拟议的各方联合检查提供任何更新，该检查旨在确认新裂缝与合同中已识别裂缝之间的对应关系。"
#let rp1_item_p003_b010_3_body = block(width: 322.9605133056641pt, height: 51.046613351851704pt)[#{ pdftr_fit_markdown(rp1_item_p003_b010_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 51.046613351851704pt) }]
#context {
  place(top + left, dx: 114.4664433836937pt, dy: 188.69048536874354pt, rp1_item_p003_b010_3_body)
}
#let rp1_item_p003_b013_4_md = "倾倒区"
#let rp1_item_p003_b013_4_body = block(width: 76.0688070911914pt, height: 15.04623800218107pt)[#{ pdftr_fit_markdown(rp1_item_p003_b013_4_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.04623800218107pt) }]
#context {
  place(top + left, dx: 107.49240287225693pt, dy: 245.132988871634pt, rp1_item_p003_b013_4_body)
}
#let rp1_item_p003_b014_5_md = "关于倾倒区，承包商仍在等待TPA的正式函件。"
#let rp1_item_p003_b014_5_body = block(width: 321.58075100183487pt, height: 9.82944337933067pt)[#{ pdftr_fit_markdown(rp1_item_p003_b014_5_md, max_size: 11.72pt, min_size: 10.92pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 9.82944337933067pt) }]
#context {
  place(top + left, dx: 114.46120890974998pt, dy: 265.27294997543095pt, rp1_item_p003_b014_5_body)
}
#let rp1_item_p003_b017_6_md = "急救设施"
#let rp1_item_p003_b017_6_body = block(width: 93.18102356046438pt, height: 15.220771475136303pt)[#{ pdftr_fit_markdown(rp1_item_p003_b017_6_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.220771475136303pt) }]
#context {
  place(top + left, dx: 108.1508850492537pt, dy: 317.81458319054246pt, rp1_item_p003_b017_6_body)
}
#let rp1_item_p003_b018_7_md = "承包商和工程师已于4月10日在供应商场地共同检查了第三个急救室集装箱，并确认其满足需求。承包商在会上告知，一旦收到来自中国的支付制造和运抵现场的资金，该集装箱将于2026年5月底前运抵现场。"
#let rp1_item_p003_b018_7_body = block(width: 326.39209089726205pt, height: 72.33897312998772pt)[#{ pdftr_fit_markdown(rp1_item_p003_b018_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 72.33897312998772pt) }]
#context {
  place(top + left, dx: 114.01281600669026pt, dy: 338.71457038314344pt, rp1_item_p003_b018_7_body)
}
#let rp1_item_p003_b021_8_md = "维护与办公空间"
#let rp1_item_p003_b021_8_body = block(width: 151.7419963002205pt, height: 15.025727165937383pt)[#{ pdftr_fit_markdown(rp1_item_p003_b021_8_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.025727165937383pt) }]
#context {
  place(top + left, dx: 109.75719424486161pt, dy: 421.85158602983955pt, rp1_item_p003_b021_8_body)
}
#let rp1_item_p003_b022_9_md = "RE向会议通报，观察到周围环境已有明显改善，即使在近期的降雨期间也未闻到异味。"
#let rp1_item_p003_b022_9_body = block(width: 321.0083640903234pt, height: 41.46337743401523pt)[#{ pdftr_fit_markdown(rp1_item_p003_b022_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 41.46337743401523pt) }]
#context {
  place(top + left, dx: 114.02824726253748pt, dy: 442.0763284400225pt, rp1_item_p003_b022_9_body)
}
#let rp1_item_p003_b025_10_md = "预制构件存放区"
#let rp1_item_p003_b025_10_body = block(width: 184.0253892093897pt, height: 8.85993558883672pt)[#{ pdftr_fit_markdown(rp1_item_p003_b025_10_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.85993558883672pt) }]
#context {
  place(top + left, dx: 110.32641514390707pt, dy: 487.6153148600578pt, rp1_item_p003_b025_10_body)
}
#let rp1_item_p003_b026_11_md = "关于港口内预制构件所需空间的问题，承包商在会上告知，他已决定从港口外采购预制构件，因此，与之前讨论的情况不同，获取港口内空间的紧迫性已不再必要。"
#let rp1_item_p003_b026_11_body = block(width: 322.3358660817146pt, height: 46.356065371513395pt)[#{ pdftr_fit_markdown(rp1_item_p003_b026_11_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 46.356065371513395pt) }]
#context {
  place(top + left, dx: 114.30627203583717pt, dy: 505.6366975376129pt, rp1_item_p003_b026_11_body)
}
#let rp1_item_p003_b027_12_md = "驻地工程师再次要求承包商提交书面文件，证明其不再需要该项设施。承包商承诺在下次会议（2026年5月21日）前提交书面文件。"
#let rp1_item_p003_b027_12_body = block(width: 324.24563294351105pt, height: 54.767397129535766pt)[#{ pdftr_fit_markdown(rp1_item_p003_b027_12_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 54.767397129535766pt) }]
#context {
  place(top + left, dx: 114.57811290174723pt, dy: 597.2527883080959pt, rp1_item_p003_b027_12_body)
}
#let rp1_item_p003_b031_13_md = "港口集装箱堆场照明"
#let rp1_item_p003_b031_13_body = block(width: 206.67609069272874pt, height: 15.292837750911758pt)[#{ pdftr_fit_markdown(rp1_item_p003_b031_13_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.292837750911758pt) }]
#context {
  place(top + left, dx: 110.48236236460507pt, dy: 661.2055483250141pt, rp1_item_p003_b031_13_body)
}
#let rp1_item_p003_b032_14_md = "承包商提交了410瓦的照明建议，但驻地工程师（RE）指出设计要求为1000瓦。RE表示已收到承包商提交的支持港口拟用照明设备的文件；并将进行审查后相应回复承包商。"
#let rp1_item_p003_b032_14_body = block(width: 323.5913518428803pt, height: 48.25544883298868pt)[#{ pdftr_fit_markdown(rp1_item_p003_b032_14_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 48.25544883298868pt) }]
#context {
  place(top + left, dx: 111.95159710645676pt, dy: 681.9208614639759pt, rp1_item_p003_b032_14_body)
}
#let rp1_item_p003_b035_15_md = "承包商开票"
#let rp1_item_p003_b035_15_body = block(width: 114.49790861643851pt, height: 15.294229495525315pt)[#{ pdftr_fit_markdown(rp1_item_p003_b035_15_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.294229495525315pt) }]
#context {
  place(top + left, dx: 107.04278207477182pt, dy: 774.0456830095768pt, rp1_item_p003_b035_15_body)
}
#let rp1_item_p003_b036_16_md = "驻地工程师建议承包商核实当前已支出金额是否低于或高于合同规定的开具发票所需的最低金额（2%）。"
#let rp1_item_p003_b036_16_body = block(width: 320.28137727230785pt, height: 40.638873131275204pt)[#{ pdftr_fit_markdown(rp1_item_p003_b036_16_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 40.638873131275204pt) }]
#context {
  place(top + left, dx: 114.57902789786458pt, dy: 796.1175251817226pt, rp1_item_p003_b036_16_body)
}
