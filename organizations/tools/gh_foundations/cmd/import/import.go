package import_cmd

import (
	"gh_foundations/internal/pkg/functions"
	"gh_foundations/internal/pkg/types"
	"log"
	"os"

	ui "github.com/gizak/termui/v3"
	"github.com/gizak/termui/v3/widgets"
	"github.com/spf13/cobra"
)

// ImportCmd represents the project command
var ImportCmd = &cobra.Command{
	Use:   "import",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: func(cmd *cobra.Command, args []string) error {
		// Optionally run one of the validators provided by cobra
		if err := cobra.MinimumNArgs(1)(cmd, args); err != nil {
			return err
		}
		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		modulePath := args[0]
		planArchive, err := functions.ArchivePlan(modulePath, "plan")
		if err != nil {
			log.Fatal(err)
			os.Exit(2)
		}
		defer planArchive.Cleanup()

		resources, err := functions.GetPlannedResourceCreations(planArchive)
		if err != nil {
			log.Fatal(err)
			os.Exit(2)
		}
		renderImportUi(*planArchive, resources)
	},
}

func renderImportUi(archive types.TerragruntPlanArchive, resources []types.TerragruntPlanOutputResourceChange) {
	addressToResourceMap := make(map[string]types.TerragruntPlanOutputResourceChange)
	resourceAddresses := make([]string, len(resources))
	for i := range resources {
		resourceAddresses[i] = resources[i].Address
		addressToResourceMap[resources[i].Address] = resources[i]
	}

	l := widgets.NewList()
	l.Title = "Resources to Import"
	l.Rows = resourceAddresses
	l.TextStyle = ui.NewStyle(ui.ColorWhite)
	l.SelectedRowStyle = ui.NewStyle(ui.ColorGreen)
	l.SelectedRow = 0
	termWidth, termHeight := ui.TerminalDimensions()
	l.SetRect(0, 0, termWidth, termHeight)
	ui.Render(l)

	showImportIdBox := false
	t := widgets.NewParagraph()
	t.Text = ""
	t.TextStyle = ui.NewStyle(ui.ColorWhite)
	t.Title = "Import ID"
	t.BorderStyle.Fg = ui.ColorWhite
	t.SetRect(termWidth/2-50, termHeight/2, termWidth/2+50, termHeight/2+3)

	for e := range ui.PollEvents() {
		if e.Type == ui.KeyboardEvent && !showImportIdBox {
			switch e.ID {
			case "<C-c>":
				return
			case "<Down>":
				l.SelectedRow = min(l.SelectedRow+1, len(l.Rows)-1)
				ui.Render(l)
			case "<Up>":
				l.SelectedRow = max(l.SelectedRow-1, 0)
				ui.Render(l)
			case "<Enter>":
				idResolver := functions.CreateImportIdResolver(addressToResourceMap[resourceAddresses[l.SelectedRow]])
				if idResolver != nil {
					id, err := idResolver.ResolveImportId()
					if err == nil {
						t.Text = id
					}
					//TODO on error we might want to display something to the user.
				}
				showImportIdBox = true
				ui.Render(t)
			}
		} else if e.Type == ui.KeyboardEvent && showImportIdBox {
			switch e.ID {
			case "<C-c>":
				return
			case "<Enter>":
				err := functions.RunImportCommand(archive, resourceAddresses[l.SelectedRow], t.Text)
				if err != nil {
					log.Fatal(err)
					os.Exit(2)
				}
				showImportIdBox = false
				t.Text = ""
				l.Rows = append(l.Rows[:l.SelectedRow], l.Rows[l.SelectedRow+1:]...)
				l.SelectedRow = 0
				ui.Render(l)
			case "<Backspace>":
				if len(t.Text) > 0 {
					t.Text = t.Text[:len(t.Text)-1]
					ui.Render(t)
				}
			default:
				t.Text += e.ID
				ui.Render(t)
			}
		}
	}
}

func init() {
	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// ImportCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// ImportCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
