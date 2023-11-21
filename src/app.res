open Footer

let encodeImageUrl = (key, value) => {
  switch key {
  | "image"
  | "logo" =>
    value
    ->Js.String2.replaceByRe(%re("/=/g"), "$image$")
    ->Js.String2.replaceByRe(%re("/\&/g"), "$image2$")
    ->Js.String2.replaceByRe(%re("/\?/g"), "$image3$")
  | _ => value
  }
}

let decodeImageUrl = (key, value) => {
  switch key {
  | "image"
  | "logo" =>
    value
    ->Js.String2.replaceByRe(%re("/\$image\$/g"), "=")
    ->Js.String2.replaceByRe(%re("/\$image2\$/g"), "&")
    ->Js.String2.replaceByRe(%re("/\$image3\$/g"), "?")
  | _ => value
  }
}

@react.component
let make = () => {
  let (image, setImage) = React.useState(_ => "")
  let (name, setName) = React.useState(_ => "")
  let (description, setDescription) = React.useState(_ => "")
  let (phone, setPhone) = React.useState(_ => "")

  let (logo, setLogo) = React.useState(_ => "")
  let (highlightText, setHighlightText) = React.useState(_ => "")
  let (extraText, setExtraText) = React.useState(_ => "")

  let params = RescriptReactRouter.useUrl()
  let setWithSearch = (setter, key, e) => {
    let search = Js.String.split("&", params.search)
    let path = params.path->Belt.List.toArray->Js.Array.joinWith("/", _)
    Js.log2("old_search", search)

    let new_search = if 0 == Js.Array2.length(search) || search[0] == "" {
      let value = encodeImageUrl(key, ReactEvent.Form.target(e)["value"])
      key ++ "=" ++ Js.Global.encodeURI(value)
    } else {
      let exist = search->Js.Array2.find(param => {
        let [search_key, _] = Js.String.split("=", param)
        search_key == key
      })
      let new_search =
        search
        ->Js.Array2.map(param => {
          let [search_key, value] = Js.String.split("=", param)
          let new_value = encodeImageUrl(search_key, ReactEvent.Form.target(e)["value"])
          switch search_key == key {
          | true => search_key ++ "=" ++ Js.Global.encodeURI(new_value)
          | false => {
              Js.log2("search_key", search_key)
              search_key ++ "=" ++ value
            }
          }
        })
        ->Js.Array.joinWith("&", _)
      switch exist {
      | Some(_) => new_search
      | None =>
        new_search ++ "&" ++ key ++ "=" ++ Js.Global.encodeURI(ReactEvent.Form.target(e)["value"])
      }
    }
    Js.log2("new_search", new_search)

    RescriptReactRouter.push(path ++ "?" ++ new_search)
    setter(ReactEvent.Form.target(e)["value"])
  }

  React.useEffect1(() => {
    let params = Js.String.split("&", params.search)

    if 0 == Js.Array2.length(params) || params[0] == "" {
      None
    } else {
      params->Js.Array2.forEach(param => {
        let [key, value] = Js.String.split("=", param)
        let decodeValue = _ => Js.Global.decodeURI(value)
        let decode_value_url = _ => {
          let new_value = value->Js.Global.decodeURI->decodeImageUrl(key, _)
          Js.log2("new_value", new_value)
          new_value
        }
        switch key {
        | "image" => setImage(decode_value_url)
        | "name" => setName(decodeValue)
        | "description" => setDescription(decodeValue)
        | "phone" => setPhone(decodeValue)
        | "logo" => setLogo(decode_value_url)
        | "highlightText" => setHighlightText(decodeValue)
        | "extraText" => setExtraText(decodeValue)
        | _ => ()
        }
      })

      None
    }
  }, [params.search])

  let create_footer = {
    image,
    name,
    description,
    phone,
    logo,
    highlightText,
    extraText,
  }

  <div className="flex flex-col items-center">
    <div>
      <h1 className="text-gray-500 text-3xl m-6"> {React.string("Html footer generator")} </h1>
      <div className="flex">
        <input
          placeholder="image url"
          className="border-2 border-gray-300 p-2 m-2"
          value={image}
          onChange={setWithSearch(setImage, "image")}
        />
        <div className="flex flex-col">
          <input
            placeholder="name"
            className="border-2 border-gray-300 p-2 m-2"
            value={name}
            onChange={setWithSearch(setName, "name")}
          />
          <input
            placeholder="description"
            className="border-2 border-gray-300 p-2 m-2"
            value={description}
            onChange={setWithSearch(setDescription, "description")}
          />
          <input
            placeholder="phone"
            className="border-2 border-gray-300 p-2 m-2"
            value={phone}
            onChange={setWithSearch(setPhone, "phone")}
          />
        </div>
      </div>
      <div>
        <input
          placeholder="logo url"
          className="border-2 border-gray-300 p-2 m-2"
          value={logo}
          onChange={setWithSearch(setLogo, "logo")}
        />
        <input
          placeholder="highlightText"
          className="border-2 border-gray-300 p-2 m-2"
          value={highlightText}
          onChange={setWithSearch(setHighlightText, "highlightText")}
        />
        <input
          placeholder="extraText"
          className="border-2 border-gray-300 p-2 m-2"
          value={extraText}
          onChange={setWithSearch(setExtraText, "extraText")}
        />
      </div>
    </div>
    <div className="mt-24">
      <h2 className="text-gray-500 text-xl m-6">
        {React.string("Manually copy footer below and paste into your email settings:")}
      </h2>
      <iframe className="border-2 p-16 w-[800px] h-[500px]" srcDoc={make_footer(create_footer)} />
    </div>
  </div>
}
