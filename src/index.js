import React from 'react'
import { render } from 'react-dom'
import { ThemeProvider } from 'styled-components'

import { library } from '@fortawesome/fontawesome-svg-core'

import { faCrown, faLink } from '@fortawesome/pro-duotone-svg-icons'
import { faGithub } from '@fortawesome/free-brands-svg-icons'
library.add(faCrown, faLink, faGithub)

// import { fab } from '@fortawesome/free-brands-svg-icons'
// import { fad } from '@fortawesome/pro-duotone-svg-icons'
// import { fal } from '@fortawesome/pro-light-svg-icons'
// import { far } from '@fortawesome/pro-regular-svg-icons'
// import { fas } from '@fortawesome/pro-solid-svg-icons'
// library.add(fab, fad, fal, far, fas)

import { defaultTheme, GlobalStyle } from 'styles'
import App from 'components/App'

render(
	<ThemeProvider theme={defaultTheme}>
		<GlobalStyle />
		<App />
	</ThemeProvider>,
	document.getElementById('root'),
)
